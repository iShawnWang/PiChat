//
//  NSNotification+UserUpdate.h
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kUserUpdateNotification=@"kUserUpdateNotification";

@class User;

@interface NSNotification (UserUpdate)
@property (strong,nonatomic,readonly) User *user;
+(void)postUserUpdateNotification:(id)object user:(User*)user;
@end
