//
//  User.m
//  PiChat
//
//  Created by pi on 16/2/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "User.h"
#import "CommenUtil.h"
#import "ImageCache.h"

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

-(void)updateUserWithCallback:(BooleanResultBlock)callback{
    self.fetchWhenSave=YES;
    [self saveInBackgroundWithBlock:callback];
}

//获取到 user 时 同时下载头像图片并缓存(内存,磁盘)起来..
-(void)setAvatarPath:(NSString *)avatarPath{
    [[ImageCache sharedImageCache]downloadAndCacheImageInBackGround:avatarPath];
}
@end
