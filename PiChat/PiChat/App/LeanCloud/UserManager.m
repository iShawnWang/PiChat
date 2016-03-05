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
#import "StoryBoardHelper.h"
#import <JSQMessagesAvatarImageFactory.h>
#import <JSQMessagesCollectionViewFlowLayout.h>
#import "ImageCache.h"
#import "Followee.h"

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
    u.fetchWhenSave=YES;
    [u signUpInBackgroundWithBlock:callback];
}

#pragma mark - Register
+(void)logInWithUserName:(NSString*)email pwd:(NSString*)pwd callback:(BooleanResultBlock)callback{
    [User logInWithUsernameInBackground:email password:pwd block:^(AVUser *user, NSError *error) {
        callback([User currentUser],error); //currentUser 不为空 ,登录成功 Yes
    }];
}

+(void)logOut {
    [User logOut];
    [StoryBoardHelper switchToLoginVC];
}

#pragma mark - Friends
+ (void)findUsersByPartname:(NSString *)partName withBlock:(AVArrayResultBlock)block {
    AVQuery *q = [User query];
    [q setCachePolicy:kAVCachePolicyNetworkOnly];
    [q whereKey:@"username" containsString:partName];
    [q whereKey:@"objectId" notEqualTo:[User currentUser].objectId];
    [q orderByDescending:@"updatedAt"];
    [q findObjectsInBackgroundWithBlock:block];
}

+(void)addFriend:(User*)user callback:(BooleanResultBlock)callback{
    [[User currentUser]follow:user.objectId andCallback:callback];
}

+(void)removeFriend:(User*)user callback:(BooleanResultBlock)callback{
    [[User currentUser]unfollow:user.objectId andCallback:callback];
}

+(void)fetchFriendsWithCallback:(ArrayResultBlock)callback {
    User *user = [User currentUser];
    AVQuery *q = [user followeeQuery];
    q.cachePolicy = kAVCachePolicyNetworkElseCache;
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        callback([Followee followeeArrayToUserArray:objects] ,error);
    }];
}

#pragma mark - Avatar

//TODO 缓存头像和用户
+(JSQMessagesAvatarImage *)avatarForClientID:(NSString *)clientID{
    UIImage *avatar;
    
    if([[UserManager sharedUserManager].currentUser.clientID isEqualToString: clientID]){
        avatar= [UIImage imageNamed:@"avatar"];
    }else{
        User *u= [User objectWithoutDataWithObjectId:clientID];
        if(u.avatarPath){
            [[ImageCache sharedImageCache]imageFromCacheForUrl:u.avatarPath];
        }
        return nil;
    }
    return [JSQMessagesAvatarImageFactory avatarImageWithImage:avatar diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
}
@end
