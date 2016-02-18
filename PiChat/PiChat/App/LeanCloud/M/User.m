//
//  User.m
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "User.h"
#import "CommenUtil.h"

@interface User ()

@end

@implementation User
@dynamic friends,clientID,avatarPath,displayName;

+(void)load{
    [User registerSubclass];
}

+(NSString *)parseClassName{
    return @"_User";
}

-(void)signUpInBackgroundWithBlock:(AVBooleanResultBlock)block{
    self.clientID=[CommenUtil uuid];
    [super signUpInBackgroundWithBlock:block];
}

@end
