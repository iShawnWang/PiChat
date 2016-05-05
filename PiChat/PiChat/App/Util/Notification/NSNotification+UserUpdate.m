//
//  NSNotification+UserUpdate.m
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NSNotification+UserUpdate.h"
#import "NSNotification+Post.h"
#import "User.h"

NSString *const kUserUpdateNotification=@"kUserUpdateNotification";
static NSString *const kUpdatedUser=@"kUpdatedUser";

@implementation NSNotification (UserUpdate)

+(void)postUserUpdateNotification:(id)object user:(User*)user{
    if(object && user){
        [[NSNotification notificationWithName:kUserUpdateNotification object:object userInfo:@{kUpdatedUser:user}]post];
    }
}

-(User *)user{
    return self.userInfo[kUpdatedUser];
}
@end
