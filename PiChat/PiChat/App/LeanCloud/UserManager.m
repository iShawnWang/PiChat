//
//  UserManager.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UserManager.h"
#import <AVOSCloud.h>
#import "CommenUtil.h"

@implementation UserManager
+(instancetype)sharedUserManager{
    static id userManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager=[UserManager new];
    });
    return userManager;
}

#pragma mark - Getter Setter
-(User*)currentUser{
    if(!_currentUser){
        _currentUser=[User currentUser];
    }
    return _currentUser;
}

#pragma mark - Login 
+(void)signUpWithUserName:(NSString *)email pwd:(NSString *)pwd callback:(BooleanResultBlock)callback{
    User *u= [User user];
    u.username=email;
    u.password=pwd;
    [u signUpInBackgroundWithBlock:callback];
}

#pragma mark - Register
+(void)logInWithUserName:(NSString*)email pwd:(NSString*)pwd callback:(BooleanResultBlock)callback{
    [User logInWithUsernameInBackground:email password:pwd block:^(AVUser *user, NSError *error) {
        callback([User currentUser],error); //currentUser 不为空 ,登录成功 Yes
    }];
}
@end
