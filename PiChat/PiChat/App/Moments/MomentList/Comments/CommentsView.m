//
//  CommentsView.m
//  PiChat
//
//  Created by pi on 16/8/6.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "CommentsView.h"
#import "Moment.h"
#import "User.h"
#import "NSString+Size.h"
#import "TTTAttributedLabel.h"
#import "FavourUserView.h"
#import <BlocksKit+UIKit.h>

#define COMMENT_HEIGHT 26
#define HEART_IMAGE_SIZE 20

@interface CommentsView ()<TTTAttributedLabelDelegate>
@property (strong,nonatomic) Moment *moment;
@end

@implementation CommentsView

-(CGFloat)configWithComments:(Moment*)moment width:(CGFloat)width{
    self.moment=moment;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGSize constraintsSize= CGSizeMake(width, CGFLOAT_MAX);
    __block CGFloat viewHeight=0;
    
    if(moment.favourUsers.count>0){
        
        FavourUserView *favourUserView=[FavourUserView loadViewFromBundle];
        favourUserView.autoresizingMask=UIViewAutoresizingNone;
        [favourUserView configWithFavourUsers:moment.favourUsers];
        
        NSInteger numberOfLine=[self numberOfLineForAttributeLabel:favourUserView.favoursLabel constraintsSize:constraintsSize];
        CGFloat actualLabelHeight=numberOfLine * COMMENT_HEIGHT;
        favourUserView.frame=CGRectMake(0, viewHeight, width,numberOfLine * COMMENT_HEIGHT);
        viewHeight+=actualLabelHeight;
        [self addSubview:favourUserView];
    }
    
    [moment.comments enumerateObjectsUsingBlock:^(Comment *comment, NSUInteger idx, BOOL * _Nonnull stop) {
        TTTAttributedLabel *label=[self commentAttributeLabel:comment];
        NSInteger numberOfLine= [self numberOfLineForAttributeLabel:label constraintsSize:constraintsSize];
        CGFloat actualLabelHeight=numberOfLine * COMMENT_HEIGHT;
        label.frame=CGRectMake(0, viewHeight, width,numberOfLine * COMMENT_HEIGHT);
        viewHeight+=actualLabelHeight;
        [self addSubview:label];
        
        @weakify(self)
        [label bk_whenTapped:^{
            @strongify(self)
            if([self.delegate respondsToSelector:@selector(commentsView:didCommentClick:withMoment:)]){
                [self.delegate commentsView:self didCommentClick:comment withMoment:self.moment];
            }
        }];
    }];
    return viewHeight;
}

-(TTTAttributedLabel *)commentAttributeLabel:(Comment*)comment{
    TTTAttributedLabel *label=[TTTAttributedLabel new];
    label.delegate=self;
    NSMutableAttributedString *attrStr;
    
    NSString *commentUserName=comment.commentUserName;
    NSString *replayToUserName=comment.replyToUserName;
    NSString *commentContent=comment.commentContent;
    if(comment.replyToUser){
        NSString *commentStr= [NSString stringWithFormat:@" %@ 回复 %@ : %@ ",commentUserName,replayToUserName,commentContent];
        attrStr=[[NSMutableAttributedString alloc]initWithString:commentStr];
        label.text=attrStr;
        [label addLinkToURL:[NSURL URLWithString:commentUserName] withRange:[commentStr rangeOfString:commentUserName]];
        [label addLinkToURL:[NSURL URLWithString:replayToUserName] withRange:[commentStr rangeOfString:replayToUserName options:NSBackwardsSearch]];
    }else{
        NSString *commentStr= [NSString stringWithFormat:@" %@ : %@ ",commentUserName,commentContent];
        attrStr=[[NSMutableAttributedString alloc]initWithString:commentStr];
        label.text=attrStr;
        [label addLinkToURL:[NSURL URLWithString:commentUserName] withRange:[commentStr rangeOfString:commentUserName]];
    }
    return label;
}



/**
 *  计算文字需要显示几行
 *
 *  @param attrLabel
 *
 *  @return
 */
-(NSInteger)numberOfLineForAttributeLabel:(TTTAttributedLabel*)attrLabel constraintsSize:(CGSize)constraintsSize{
    CGSize labelSize= [TTTAttributedLabel sizeThatFitsAttributedString:attrLabel.attributedText withConstraints:constraintsSize limitedToNumberOfLines:0];
    NSInteger numberOfLine= ceil(labelSize.height/attrLabel.font.lineHeight);
    return numberOfLine;

}

@end
