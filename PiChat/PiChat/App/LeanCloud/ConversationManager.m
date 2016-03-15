//
//  ConversationManager.m
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ConversationManager.h"
#import "NSNotification+ReceiveMessage.h"

@interface ConversationManager  ()<AVIMClientDelegate>
@property (copy,nonatomic) NSOperationQueue *netQueue;
@end

@implementation ConversationManager

+(instancetype)sharedConversationManager{
    static id conversationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        conversationManager=[ConversationManager new];
    });
    return conversationManager;
}

-(void)setupConversationClientWithCallback:(BooleanResultBlock)callback{
    self.client=[[AVIMClient alloc]initWithClientId:self.currentUser.clientID];
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            self.netQueue.suspended=NO;
        }
        callback(succeeded,error);
    }];
    self.client.delegate=self;
}

-(NSOperationQueue *)netQueue{
    if(!_netQueue){
        _netQueue=[[NSOperationQueue alloc]init];
        _netQueue.maxConcurrentOperationCount=4;
        _netQueue.suspended=YES;
    }
    return _netQueue;
}

-(User *)currentUser{
    return [User currentUser];
}

- (AVIMConversationQuery *)conversationQuery{
    return [self.client conversationQuery];
}

#pragma mark -

/**
 *  先查询当前用户和 clientID 的对话,找不到就创建
 *
 *  @param clientID
 *  @param callback
 */
-(void)findOrCreatePrivateConversationWithClentID:(NSString*)clientID callback:(AVIMConversationResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        
        NSArray *clientIDs=@[self.client.clientId,clientID];
        [self findPrivateConversationWith2ClientIDs:clientIDs callback:^(AVIMConversation *conversation, NSError *error) {
            if(conversation){//找到对话
                callback(conversation,error);
            }else if(error){//找对话出错
                callback(conversation,error);
            }else{//创建对话
                [self createPrivateConversationWith2ClientIDs:clientIDs callback:callback];
            }
        }];
        
    }]];
    
}

/**
 *  查询1vs1的对话
 *
 *  @param clientIDs
 *  @param callback
 */
-(void)findPrivateConversationWith2ClientIDs:(NSArray*)clientIDs callback:(AVIMConversationResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        
        AVIMConversationQuery *query = [self conversationQuery];
        [query whereKey:@"m" containsAllObjectsInArray:clientIDs];
        [query whereKey:@"m" sizeEqualTo:2];
        query.cachePolicy=kAVIMCachePolicyNetworkOnly;
        [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            callback([objects firstObject],error);
        }];
        
    }]];
    
    
}

/**
 *  创建1vs1的对话
 *
 *  @param clientIDs
 *  @param callback
 */
-(void)createPrivateConversationWith2ClientIDs:(NSArray*)clientIDs callback:(AVIMConversationResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        
        [self.client createConversationWithName:@"" clientIds:clientIDs callback:callback];
        
    }]];
}

/**
 *  根据对话 ID 查找对话
 *
 *  @param conversationID
 *  @param callback
 */
-(void)findConversationByConversationID:(NSString*)conversationID callback:(AVIMConversationResultBlock)callback{
    
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        
        [[self conversationQuery]getConversationById:conversationID callback:callback];
        
    }]];
    
}

/**
 *  根据对话 ID 加入对话
 *
 *  @param conversationID
 *  @param callback
 */
-(void)joinConversationByConversationID:(NSString*)conversationID callback:(AVIMConversationResultBlock)callback{
    
    
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [self findConversationByConversationID:conversationID callback:^(AVIMConversation *conversation, NSError *error) {
            if(!conversation){
                callback(conversation,error);
                return;
            }
            [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
                callback(conversation,error);
            }];
        }];
    }]];
}

/**
 *  加入对话
 *
 *  @param conversation
 *  @param callback
 */
-(void)joinConversation:(AVIMConversation*)conversation callback:(BooleanResultBlock)callback{
    
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [conversation joinWithCallback:callback];
    }]];
}

/**
 *  和 XX 聊天
 *
 *  @param u
 *  @param callback
 */
-(void)chatToUser:(NSString*)clientID callback:(AVIMConversationResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [self findOrCreatePrivateConversationWithClentID:clientID callback:^(AVIMConversation *conversation, NSError *error) {
            [self joinConversation:conversation callback:^(BOOL succeeded, NSError *error) {
                callback(succeeded ? conversation : nil,error);
            }];
        }];
    }]];
}

/**
 *  查询对话的最近消息... 打开消息界面后,调用这个方法...展示最近的10条聊天消息
 *
 *  @param conversation
 *  @param callback
 */
-(void)fetchConversationMessages:(AVIMConversation*)conversation callback:(AVIMArrayResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [conversation queryMessagesWithLimit:10 callback:callback];
    }]];
}

/**
 *  查询对话消息记录 ,历史消息
 *
 *  @param conversation
 *  @param beforeID
 *  @param callback
 */
-(void)fetchMessages:(AVIMConversation*)conversation before:(NSString*)beforeID callback:(AVIMArrayResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [conversation queryMessagesBeforeId:beforeID timestamp:0 limit:20 callback:callback];
    }]];
}

/**
 *  查询对话消息记录 ,历史消息 按时间戳
 *
 *  @param conversation
 *  @param
 *  @param callback
 */
-(void)fetchMessages:(AVIMConversation*)conversation beforeTime:(int64_t)beforeTimeStamp callback:(AVIMArrayResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [conversation queryMessagesBeforeId:nil timestamp:beforeTimeStamp limit:20 callback:callback];
    }]];
}

/**
 *  查询最近的会话,
 *
 *  @param conversation
 *  @param callback
 */
-(void)fetchReventConversations:(ArrayResultBlock)callback{
    [self.netQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        AVIMConversationQuery *query= [self.client conversationQuery];
        [query whereKey:kAVIMKeyMember containsString:self.client.clientId];
        [query orderByDescending:@"updatedAt"];
        query.limit=20;
        [query findConversationsWithCallback:callback];
    }]];
}


#pragma mark - AVIMClientDelegate

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
//    NSLog(@"%@ : %@",@"收到 message",message);
    [NSNotification postReceiveMessageNotification:self message:message];
}
@end
