//
//  User.h
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import "GlobalConstant.h"

@interface User:AVUser<AVSubclassing,NSCoding>
//chat
@property (copy,nonatomic) NSString *clientID; //唯一的 uuid,作为 Leancloud 聊天的唯一 ID
@property (copy,nonatomic) NSString *avatarPath;
@property (copy,nonatomic) NSString *displayName;
//
-(void)updateUserWithCallback:(UserResultBlock)callback;
@end
