//
//  CommentsView.h
//  PiChat
//
//  Created by pi on 16/8/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class Moment;
@class Comment;
@class CommentsView;

@protocol CommentsViewDelegate <NSObject>
@optional
-(void)commentsView:(CommentsView*)commentsView didCommentClick:(Comment*)comment withMoment:(Moment*)moment;

@end

@interface CommentsView : UIView
@property(nonatomic,weak) IBOutlet id<CommentsViewDelegate> delegate;
-(CGFloat)configWithComments:(Moment*)moment width:(CGFloat)width;
@end
