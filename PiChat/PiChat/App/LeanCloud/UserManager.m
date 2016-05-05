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
#import "PiAutoPurgeCache.h"
#import "NSNotification+UserUpdate.h"


@interface UserManager ()
@property (strong,nonatomic) PiAutoPurgeCache *userCache;
@end

@implementation UserManager
+(instancetype)sharedUserManager{
    static id userManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager=[UserManager new];
    });
    return userManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userUpdateNotification:) name:kUserUpdateNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Getter Setter
-(User*)currentUser{
    return [User currentUser];
}

-(PiAutoPurgeCache*)userCache{
    if(!_userCache){
        _userCache=[PiAutoPurgeCache new];
    }
    return _userCache;
}

#pragma mark - Register 
-(void)signUpWithUserName:(NSString *)email pwd:(NSString *)pwd callback:(BooleanResultBlock)callback{
    User *u= [User user];
    u.username=email;
    u.password=pwd;
    u.avatarPath=@"http://7xqpoa.com1.z0.glb.clouddn.com/_doggy.jpg"; //FIXME 默认头像测试
    u.fetchWhenSave=YES;
    
    [u signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.userCache setObject:u forKey:u.objectId];
        callback(succeeded,error);
    }];
}

#pragma mark - Login
-(void)logInWithUserName:(NSString*)email pwd:(NSString*)pwd callback:(BooleanResultBlock)callback{
    [User logInWithUsernameInBackground:email password:pwd block:^(AVUser *user, NSError *error) {
        [self.userCache setObject:user forKey:user.objectId];
        callback([User currentUser] !=nil,error); //currentUser 不为空 ,登录成功 Yes
    }];
}

+(void)logOut {
    [User logOut];
    [StoryBoardHelper switchToLoginVC];
}

#pragma mark - Friends
- (void)findUsersByPartname:(NSString *)partName withBlock:(AVArrayResultBlock)block {
    AVQuery *q = [User query];
    [q setCachePolicy:kAVCachePolicyNetworkOnly];
    [q whereKey:kUsernameKey containsString:partName];
    [q whereKey:kObjectIdKey notEqualTo:[User currentUser].objectId];
    [q orderByDescending:kUpdatedAt];
    [q findObjectsInBackgroundWithBlock:block];
}

/**
 *  先从缓存中找用户,找不到就下载.立即返回 nil
 *
 *  @param clientID
 *
 *  @return
 */
-(User *)findUserFromCacheElseNetworkByClientID:(NSString*)clientID{
    User *u= [self findUserFromCacheByClientID:clientID];
    if(!u){
        [self findUserFromNetworkByClientID:clientID callback:nil];
    }
    return u;
}

/**
 *  先内存缓存,在磁盘缓存
 *
 *  @param clientID
 *
 *  @return
 */
-(User*)findUserFromCacheByClientID:(NSString*)clientID{
    User *u=[self.userCache objectForKey:clientID];
    if(u){
        return u;
    }else{
        AVQuery *q=[User query];
        q.cachePolicy=kAVCachePolicyCacheOnly;
        [q whereKey:kObjectIdKey equalTo:clientID];
        NSError *error;
        u=[[q findObjects:&error]firstObject];
        if(u){
            [self.userCache setObject:u forKey:u.objectId];
        }
    }
    return u;
}

-(void)findUserByClientID:(NSString*)clientID callback:(UserResultBlock)callback {
    //先查询内存缓存是否有用户
    User *u= [self findUserFromCacheByClientID:clientID];
    if(u){
        callback(u,nil);
        return;
    }
    //没有就从网络 fetch 
    [self findUserFromNetworkByClientID:clientID callback:callback];
}

/**
 *  从网络查询 User
 *
 *  @param clientID
 *  @param callback
 */
-(void)findUserFromNetworkByClientID:(NSString *)clientID callback:(UserResultBlock)callback{
    AVQuery *q=[User query];
    [q whereKey:kObjectIdKey equalTo:clientID];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        User *u=[objects firstObject];
        [self.userCache setObject:u forKey:u.objectId];
        [NSNotification postUserUpdateNotification:self user:u];
        if(callback){
            callback(u,error);
        }
    }];
}

-(void)addFriend:(User*)user callback:(BooleanResultBlock)callback{
    [[User currentUser]follow:user.objectId andCallback:callback];
}

-(void)removeFriend:(User*)user callback:(BooleanResultBlock)callback{
    [[User currentUser]unfollow:user.objectId andCallback:callback];
}

-(void)fetchFriendsWithCallback:(ArrayResultBlock)callback {
    User *user = [User currentUser];
    AVQuery *q = [user followeeQuery];
    q.cachePolicy = kAVCachePolicyNetworkElseCache; //TODO 联系人列表 先缓存在网络
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        callback([Followee followeeArrayToUserArray:objects] ,error);
    }];
}

#pragma mark - Avatar
-(JSQMessagesAvatarImage *)avatarForClientID:(NSString *)clientID {
    return [self avatarForClientID:clientID size:CGSizeZero];
}

-(JSQMessagesAvatarImage *)avatarForClientID:(NSString *)clientID size:(CGSize)size{
    UIImage *avatar;
    User *u= [self findUserFromCacheByClientID:clientID];
    if(u.avatarPath){
        avatar=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
    }else{
        avatar=[UIImage new];
        [self findUserByClientID:clientID callback:^(User *user, NSError *error) {
            [[ImageCache sharedImageCache]findOrFetchImageFormUrl:u.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
        }];
    }
    
    return [JSQMessagesAvatarImage avatarWithImage:avatar];
}

#pragma mark - 用户更新完毕,加入到缓存中
-(void)userUpdateNotification:(NSNotification*)noti{
    User *u= noti.user;
    [self.userCache setObject:u forKey:u.objectId];
}
@end
