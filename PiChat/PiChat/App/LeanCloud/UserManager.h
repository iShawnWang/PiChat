//
//  UserManager.h
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "GlobalConstant.h"

@interface UserManager : NSObject
@property (strong,nonatomic) User *currentUser;
//
+(instancetype)sharedUserManager;
//
+(void)signUpWithUserName:(NSString*)email pwd:(NSString*)pwd callback:(BooleanResultBlock)callback;
//
+(void)logInWithUserName:(NSString*)email pwd:(NSString*)pwd callback:(BooleanResultBlock)callback;
@end
