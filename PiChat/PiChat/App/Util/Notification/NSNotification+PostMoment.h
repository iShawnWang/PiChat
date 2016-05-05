//
//  NSNotification+PostMoment.h
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPostMomentNotification;

typedef NS_ENUM(NSUInteger, PostMomentState) {
    PostMomentStateComplete,
    PostMomentStateProgress,
    PostMomentStateFailed,
};
@class Moment;

@interface NSNotification (PostMoment)
@property (assign,nonatomic,readonly) PostMomentState postState;
@property (assign,nonatomic,readonly) float postProgress;
@property (strong,nonatomic,readonly) NSError *error;
@property (strong,nonatomic,readonly) Moment *moment;

+(void)postPostMomentProgressNotification:(id)obj progress:(NSInteger)progress;

+(void)postPostMomentCompleteNotification:(id)obj moment:(Moment*)moment;

+(void)postPostMomentFailedNotification:(id)obj error:(NSError*)error;
@end
