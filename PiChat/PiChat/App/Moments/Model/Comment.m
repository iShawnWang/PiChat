//
//  Comment.m
//  PiChat
//
//  Created by pi on 16/4/2.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@dynamic commentUser,commentContent,replyToUser,commentUserName,replyToUserName;

+(instancetype)commentWithCommentUser:(User*)u commentContent:(NSString*)content replayTo:(User*)replyToUser{
    Comment *c=[Comment object];
    c.commentUser=u;
    c.commentUserName=u.displayName;
    c.commentContent=content;
    c.replyToUser=replyToUser;
    if(!replyToUser.displayName){
        if([replyToUser fetch]){
            c.replyToUserName=replyToUser.displayName;
        }
    }
    
    return c;
}
                          
+(void)load{
    [Comment registerSubclass];
}

+(NSString *)parseClassName{
    return NSStringFromClass([Comment class]);
}

-(NSUInteger)hash{
    return  self.commentUser.objectId.hash ^ self.replyToUser.objectId.hash ^ self.commentContent.hash;
}
@end
