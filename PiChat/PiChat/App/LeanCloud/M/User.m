//
//  User.m
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "User.h"

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


-(BOOL)signUp:(NSError *__autoreleasing *)error{
    NSException *e =[NSException exceptionWithName:NSGenericException reason:@"use -signUpInBackgroundWithBlock:(AVBooleanResultBlock)block instead" userInfo:nil];
    @throw e;
}

-(void)signUpInBackgroundWithBlock:(AVBooleanResultBlock)block{
    self.clientID=[User uuid];
    [super signUpInBackgroundWithBlock:block];
}

#pragma mark - Private
+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
@end
