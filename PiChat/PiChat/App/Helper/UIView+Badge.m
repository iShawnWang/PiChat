//
//  UIView+Bedge.m
//  PiChat
//
//  Created by pi on 16/5/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UIView+Badge.h"
#import "CommenUtil.h"


@implementation UIView (Badge)
-(void)showBadgeWithCount:(NSInteger)count{
    __block BOOL hasBadgeAlready=NO;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
        if([v isKindOfClass:[JSBadgeView class]]){
            JSBadgeView *badge= (JSBadgeView*)v;
            badge.badgeText=[self textFromCount:count];
            *stop=YES;
            hasBadgeAlready=YES;
        }
    }];
    if(hasBadgeAlready){
        return;
    }
    JSBadgeView *badge= [[JSBadgeView alloc]initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
    badge.badgeText=[self textFromCount:count];
}

-(JSBadgeView*)badgeView{
    __block JSBadgeView *badge;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *v, NSUInteger idx, BOOL * _Nonnull stop) {
        if([v isKindOfClass:[JSBadgeView class]]){
            *stop=YES;
            badge=(JSBadgeView*)v;
        }
    }];
    return badge;
}

-(NSInteger)badgeCount{
    if([self.badgeView.badgeText isEmptyString]){
        return 0;
    }
    return [self.badgeView.badgeText integerValue];
}

-(void)removeBadge{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
        if([v isKindOfClass:[JSBadgeView class]]){
            [v removeFromSuperview];
        }
    }];
}

-(NSString*)textFromCount:(NSInteger)count{
    return [NSString stringWithFormat:@"%@",@(count)];
}
@end
