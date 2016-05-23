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
#import "AddFriendRequest.h"

@class JSQMessagesAvatarImage;

@interface UserManager : NSObject
@property (strong,nonatomic) User *currentUser;
//
+(instancetype)sharedUserManager;
//注册
-(void)signUpWithUserName:(NSString*)email pwd:(NSString*)pwd callback:(BooleanResultBlock)callback;

//登录
-(void)logInWithUserName:(NSString*)email pwd:(NSString*)pwd callback:(BooleanResultBlock)callback;
+(void)logOut;

//联系人
-(void)findUsersByPartname:(NSString *)partName withBlock:(AVArrayResultBlock)block;

/**
 *  从缓存中获取 User, 如果缓存中没有,立即返回 nil, 并从网络加载 User, 加载完成后发送通知
 *
 *  @param objectID
 *
 *  @return 
 */
-(User *)findUserFromCacheElseNetworkByObjectID:(NSString*)objectID;

/**
 *  只从缓存中获取 User, 没有就返回 nil.
 *
 *  @param objectID
 *
 *  @return
 */
-(User*)findUserFromCacheByObjectID:(NSString*)objectID;

/**
 *  异步获取 User, 先查询缓存,没有就下载.
 *
 *  @param objectID
 *  @param callback
 */
-(void)findUserByObjectID:(NSString*)objectID callback:(UserResultBlock)callback;

/**
 *  只从网络加载 User
 *
 *  @param objectID
 *  @param callback
 */
-(void)findUserFromNetworkByObjectID:(NSString *)objectID callback:(UserResultBlock)callback;

//好友
-(void)isMyFriend:(User*)user callback:(BooleanResultBlock)callback;
-(void)addFriend:(User*)user callback:(BooleanResultBlock)callback;
-(void)removeFriend:(User*)user callback:(BooleanResultBlock)callback;
-(void)fetchFriendsWithCallback:(ArrayResultBlock)callback;

/**
 *  向某人发送好友请求
 *
 *  @param userToAdd
 *  @param verifyMsg
 *  @param callback
 */
-(void)postAddFriendRequestTo:(User*)userToAdd verifyMessage:(NSString*)verifyMsg callBack:(BooleanResultBlock)callback;

/**
 *  获取所有关于我的好友请求
 *
 *  @param u
 *  @param callback 
 */
-(void)findAddFriendRequestAboutUser:(User*)u callback:(ArrayResultBlock)callback;

//用户头像图片
/**
 *  根据 clientID 同步(阻塞)查找本地缓存的用户,返回用户在缓存中的头像,缓存中不存在用户,或者不存在头像,都返回 nil
 *
 *  @param clientID
 *
 *  @return
 */
-(JSQMessagesAvatarImage *)avatarForObjectID:(NSString *)objectID;
@end
