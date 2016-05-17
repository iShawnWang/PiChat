//
//  UIView+Bedge.m
//  PiChat
//
//  Created by pi on 16/5/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UIView+Bedge.h"


@implementation UIView (Bedge)
-(void)showBedgeWithCount:(NSInteger)count{
    __block BOOL hasBedgeAlready=NO;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull v, NSUInteger idx, BOOL * _Nonnull stop) {
        if([v isKindOfClass:[JSBadgeView class]]){
            JSBadgeView *bedge= (JSBadgeView*)v;
            bedge.badgeText=[self textFromCount:count];
            *stop=YES;
            hasBedgeAlready=YES;
        }
    }];
    if(hasBedgeAlready){
        return;
    }
    JSBadgeView *bedge= [[JSBadgeView alloc]initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
    bedge.badgeText=[self textFromCount:count];
}

-(void)removeBedge{
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
