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

@class User;

FOUNDATION_EXPORT NSString *const kPostUser;
FOUNDATION_EXPORT NSString *const kPostImages;
FOUNDATION_EXPORT NSString *const kPostContent;
FOUNDATION_EXPORT NSString *const kFavourUsers;
FOUNDATION_EXPORT NSString *const kComments;

@interface Moment : AVObject<AVSubclassing,UniqueObject>
@property (strong,nonatomic) User *postUser;
@property (copy,nonatomic) NSArray *favourUsers; //赞过的人
@property (copy,nonatomic) NSArray *comments; //别人的评论
@property (copy,nonatomic) NSArray *images;
@property (copy,nonatomic) NSString *texts;

-(void)addOrRemoveFavourUser:(User *)u;
-(void)addNewComment:(Comment*)comment;
-(void)saveInBackgroundThenFetch:(MomentResultBlock)callback;
@end
