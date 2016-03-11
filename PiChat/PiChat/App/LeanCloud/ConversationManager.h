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

@class AVIMClient;
@interface ConversationManager : NSObject
@property (strong,nonatomic) User *currentUser;
@property (strong,nonatomic) AVIMClient *client;
//
+(instancetype)sharedConversationManager;
-(void)setupConversationClientWithCallback:(BooleanResultBlock)callback;
//对话
-(void)chatToUser:(User*)u callback:(AVIMConversationResultBlock)callback;
-(void)fetchConversationMessages:(AVIMConversation*)conversation callback:(AVIMArrayResultBlock)callback;
-(void)fetchMessages:(AVIMConversation*)conversation before:(NSString*)beforeID callback:(AVIMArrayResultBlock)callback;
-(void)fetchMessages:(AVIMConversation*)conversation beforeTime:(int64_t)beforeTimeStamp callback:(AVIMArrayResultBlock)callback;
@end
