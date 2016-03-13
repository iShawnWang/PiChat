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
-(User *)findUserFromCacheElseNetworkByClientID:(NSString*)clientID;
-(User*)findUserFromCacheByClientID:(NSString*)clientID;
-(void)findUserFromNetworkByClientID:(NSString *)clientID callback:(UserResultBlock)callback;
-(void)findUserByClientID:(NSString*)clientID callback:(UserResultBlock)callback;
-(void)findUsersByPartname:(NSString *)partName withBlock:(AVArrayResultBlock)block;
//
-(void)addFriend:(User*)user callback:(BooleanResultBlock)callback;
-(void)removeFriend:(User*)user callback:(BooleanResultBlock)callback;
-(void)fetchFriendsWithCallback:(ArrayResultBlock)callback;

//用户头像图片
/**
 *  根据 clientID 同步(阻塞)查找本地缓存的用户,返回用户在缓存中的头像,缓存中不存在用户,或者不存在头像,都返回 nil
 *
 *  @param clientID
 *
 *  @return
 */
-(JSQMessagesAvatarImage *)avatarForClientID:(NSString *)clientID;
@end
