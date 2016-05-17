//
//  AddFriendRequest.h
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import "User.h"

//等待验证,接受,拒绝
typedef enum : NSUInteger {
    AddFriendRequestStatusWait,
    AddFriendRequestStatusAccept,
    AddFriendRequestStatusDeny
} AddFriendRequestStatus;


static NSString *const kFromUserKey=@"fromUser";
static NSString *const kToUserKey=@"toUser";
static NSString *const kIsReadKey=@"isRead";
static NSString *const kStatusKey=@"status";
static NSString *const kVerifyMessageKey=@"verifyMessage";

@interface AddFriendRequest : AVObject<AVSubclassing>
@property (strong,nonatomic) User *fromUser;
@property (strong,nonatomic) User *toUser;
@property (assign,nonatomic) BOOL isRead; //没读过就显示红点, bedge
@property (copy,nonatomic) NSString *verifyMessage; //验证消息, 我是你的 XXX

@property (assign,nonatomic) AddFriendRequestStatus status;

+(instancetype)requestWithUserToAdd:(User*)userToAdd;
+(instancetype)requestWithUserToAdd:(User*)userToAdd verifyMsg:(NSString*)verifyMsg;
@end
