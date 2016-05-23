//
//  UIView+Bedge.h
//  PiChat
//
//  Created by pi on 16/5/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSBadgeView.h>

@interface UIView (Bedge)
/**
 *  为某个 View 显示右上方的小红点
 *
 *  @param count
 */
-(void)showBedgeWithCount:(NSInteger)count;

/**
 *  清除小红点
 */
-(void)removeBedge;
@end
