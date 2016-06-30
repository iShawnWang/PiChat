//
//  Comment.h
//  PiChat
//
//  Created by pi on 16/4/2.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <AVOSCloud.h>
#import "User.h"

@interface Comment : AVObject<AVSubclassing,NSCoding>
@property (strong,nonatomic) User *commentUser; //评论用户
@property (strong,nonatomic) User *replyToUser; //关联用户
@property (copy,nonatomic) NSString *commentUserName;
@property (copy,nonatomic) NSString *replyToUserName;
@property (copy,nonatomic) NSString* commentContent; //评论内容

/**
 *  创建一条评论
 *
 *  @param u
 *  @param content
 *  @param replayToUser 回复 XXX的评论
 *
 *  @return
 */
+(instancetype)commentWithCommentUser:(User*)u commentContent:(NSString*)content replayTo:(User*)replayToUser;
@end
