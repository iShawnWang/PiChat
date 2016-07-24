//
//  NSNotification+UserUpdate.h
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kUserUpdateNotification ;

@class User;

/**
 *  用户更新成功的通知
 */
@interface NSNotification (UserUpdate)
@property (strong,nonatomic,readonly) User *user;
+(void)postUserUpdateNotification:(id)object user:(User*)user;
@end
