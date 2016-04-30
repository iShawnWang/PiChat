//
//  Moment.m
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Moment.h"
#import "User.h"

@implementation Moment
@dynamic images,texts,postUser,favourUsers,comments;

+(void)load{
    [Moment registerSubclass];
}

+(NSString *)parseClassName{
    return @"Moment";
}

-(NSUInteger)hash{
    return self.postUser.objectId.hash ^ self.favourUsers.hash ^ self.comments.hash ^ self.comments.hash ^ self.images.hash ^ self.texts.hash;
}

#pragma mark - Public

/**
 *  添加赞这个朋友圈的用户,如果用户已经赞了,就取消赞
 *
 *  @param u
 */
-(void)addOrRemoveFavourUser:(User *)u{
    NSMutableArray *newFavourUsers=[NSMutableArray arrayWithArray:self.favourUsers];
    if([newFavourUsers containsObject:u]){
        [newFavourUsers removeObject:u];
    }else{
        [newFavourUsers addObject:u];
    }
    self.favourUsers=[newFavourUsers copy];
}

/**
 *  添加对这个朋友圈的评论
 *
 *  @param comment 
 */
-(void)addNewComment:(Comment*)comment{
    NSMutableArray *comments=[NSMutableArray arrayWithArray:self.comments];
    [comments addObject:comment];
    self.comments=[comments copy];
}

-(void)saveInBackgroundThenFetch:(MomentResultBlock)callback{
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            callback(nil,error);
            return ;
        }
        AVQuery *momentQuery= [AVQuery queryWithClassName:NSStringFromClass([Moment class])];
        [momentQuery whereKey:kObjectIdKey equalTo:self.objectId];
        [momentQuery includeKey:kPostImages];
        [momentQuery includeKey:kFavourUsers];
        [momentQuery includeKey:kComments];
        [momentQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            Moment *m=object ? (Moment*)object : nil;
            callback(m,error);
        }];
    }];
}


@end
