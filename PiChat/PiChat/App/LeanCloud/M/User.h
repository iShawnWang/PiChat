//
//  User.h
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

@interface User:AVUser<AVSubclassing>
//chat
@property (copy,nonatomic) NSString *clientID;
@property (copy,nonatomic) NSString *avatarPath;
@property (copy,nonatomic) NSString *displayName;
//firend
@property (strong,nonatomic) AVRelation *friends;
@end
