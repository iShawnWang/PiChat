//
//  Moment.h
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <AVOSCloud.h>
#import "Comment.h"
#import "GlobalConstant.h"
#import "ModelSizeCache.h"
#import "AVFile+FICEntity.h"

@class User;
@class YapDatabaseConnection;
@class YapDatabaseViewMappings;

FOUNDATION_EXPORT NSString *const kPostUser;
FOUNDATION_EXPORT NSString *const kPostImages;
FOUNDATION_EXPORT NSString *const kPostContent;
FOUNDATION_EXPORT NSString *const kFavourUsers;
FOUNDATION_EXPORT NSString *const kComments;

@interface Moment : AVObject<AVSubclassing,NSCoding,ModelSizeCacheProtocol>
@property (strong,nonatomic) User *postUser;
@property (copy,nonatomic) NSArray<User*> *favourUsers; //赞过的人
@property (copy,nonatomic) NSArray<Comment*> *comments; //别人的评论
@property (copy,nonatomic) NSArray<AVFile*> *images;
@property (copy,nonatomic) NSString *texts;

/**
 *  添加赞这个朋友圈的用户,如果用户已经赞了,就取消赞
 *
 *  @param u
 */
-(void)addOrRemoveFavourUser:(User *)u;

/**
 *  添加对这个朋友圈的评论
 *
 *  @param comment
 */
-(void)addNewComment:(Comment*)comment;

/**
 *  更新或者保存Moment 到服务器上,保存成功后存入数据库,
 *
 *  @param callback
 */
-(void)saveOrUpdateInBackground:(BooleanResultBlock)callback;

/**
 *  根据 readConnection , Mapping ,indexPath,从数据库获取相应的 Moment
 *
 *  @param connection
 *  @param indexPath
 *  @param mapping
 *
 *  @return
 */
+(instancetype)momentFromDBWithConnection:(YapDatabaseConnection*)connection indexPath:(NSIndexPath*)indexPath mapping:(YapDatabaseViewMappings*)mapping;
@end
