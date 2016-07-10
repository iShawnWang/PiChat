//
//  User.m
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "User.h"
#import "CommenUtil.h"
#import "NSNotification+UserUpdate.h"

NSString *const kUserCodingKey = @"kUserCodingKey";
NSString *const kAvatarPathKey = @"kAvatarPathKey";

@interface User ()

@end

@implementation User
@dynamic avatarPath,displayName;

+(void)load{
    [User registerSubclass];
}

+(NSString *)parseClassName{
    return @"_User";
}

-(void)signUpInBackgroundWithBlock:(AVBooleanResultBlock)block{
    self.displayName=self.username;
    self.email=self.username;
    [super signUpInBackgroundWithBlock:block];
}

/**
 *  ObjectID 作为 clientID 反正唯一就行...
 *
 *  @return
 */
-(NSString *)clientID{
    return self.objectId;
}

-(void)updateUserWithCallback:(UserResultBlock)callback{
    self.fetchWhenSave=YES;
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [NSNotification postUserUpdateNotification:self user:self];
        callback([User currentUser],error);
    }];
}

#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSDictionary *objDict= [self dictionaryForObject];
    [aCoder encodeObject:objDict forKey:kUserCodingKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    NSDictionary *objDict= [coder decodeObjectForKey:kUserCodingKey];
    return (User*)[AVObject objectWithDictionary:objDict];
}

@end
