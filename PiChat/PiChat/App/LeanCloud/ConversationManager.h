//
//  ConversationManager.h
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import <AVOSCloud.h>
#import <AVOSCloudIM.h>
#import "User.h"
#import "AVIMConversation+Addition.h"

@class AVIMClient;
@interface ConversationManager : NSObject
@property (strong,nonatomic) User *currentUser;
@property (strong,nonatomic) AVIMClient *client;
//
+(instancetype)sharedConversationManager;
/**
 *  必须在程序初始化时调用这个方法,才能开始聊天相关的东西.
 *
 *  @param callback
 */
-(void)setupConversationClientWithCallback:(BooleanResultBlock)callback;

//对话
-(void)chatToUser:(NSString*)clientID callback:(AVIMConversationResultBlock)callback;

/**
 *  加载聊天记录,默认10条
 *
 *  @param conversation
 *  @param callback
 */
-(void)fetchConversationMessages:(AVIMConversation*)conversation callback:(AVIMArrayResultBlock)callback;

/**
 *  查询历史消息,根据某条消息 ID
 *
 *  @param conversation
 *  @param beforeID
 *  @param callback
 */
-(void)fetchMessages:(AVIMConversation*)conversation before:(NSString*)beforeID callback:(AVIMArrayResultBlock)callback;

/**
 *  查询历史消息,根据时间戳
 *
 *  @param conversation
 *  @param beforeTimeStamp
 *  @param callback        
 */
-(void)fetchMessages:(AVIMConversation*)conversation beforeTime:(int64_t)beforeTimeStamp callback:(AVIMArrayResultBlock)callback;

/**
 *  获取关于我的最近的所有会话.
 *
 *  @param callback <#callback description#>
 */
-(void)fetchReventConversations:(ArrayResultBlock)callback;
@end
