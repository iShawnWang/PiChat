//
//  NSNotification+PostMoment.m
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NSNotification+PostMoment.h"
#import "NSNotification+Post.h"
#import "Moment.h"

NSString *const kPostState=@"kPostState";
NSString *const kPostProgress=@"kPostProgress";
NSString *const kPostError=@"kPostError";
NSString *const kPostedMoment=@"kPostedMoment";

@implementation NSNotification (PostMoment)

+(void)postPostMomentProgressNotification:(id)obj progress:(NSInteger)progress{
    [[NSNotification notificationWithName:kPostMomentNotification object:obj userInfo:@{kPostState:@(PostMomentStateProgress),kPostProgress:@(progress/100.0)}]post];
}

+(void)postPostMomentCompleteNotification:(id)obj moment:(Moment*)moment{
    [[NSNotification notificationWithName:kPostMomentNotification object:obj userInfo:@{kPostState:@(PostMomentStateComplete),kPostedMoment:moment}]post];
}

+(void)postPostMomentFailedNotification:(id)obj error:(NSError*)error{
    [[NSNotification notificationWithName:kPostMomentNotification object:obj userInfo:@{kPostState:@(PostMomentStateFailed),kPostError:error}]post];
}

-(PostMomentState)postState{
    return [self.userInfo[kPostState] integerValue];
}

-(float)postProgress{
    return [self.userInfo[kPostProgress]floatValue];
}

-(NSError *)error{
    return self.userInfo[kPostError];
}

-(Moment *)moment{
    return self.userInfo[kPostedMoment];
}
@end
