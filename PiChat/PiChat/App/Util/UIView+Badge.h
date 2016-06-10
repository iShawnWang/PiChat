//
//  UIView+Bedge.h
//  PiChat
//
//  Created by pi on 16/5/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSBadgeView.h>

@interface UIView (Badge)
/**
 *  为某个 View 显示右上方的小红点
 *
 *  @param count
 */
-(void)showBadgeWithCount:(NSInteger)count;

/**
 *  清除小红点
 */
-(void)removeBadge;

/**
 *  附着的 badge,没有就返回 nil
 *
 *  @return
 */
-(JSBadgeView*)badgeView;

/**
 *  当前badge 的数字
 *
 *  @return
 */
-(NSInteger)badgeCount;
@end
