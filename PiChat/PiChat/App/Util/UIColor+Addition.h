//
//  UIColor+Addition.h
//  UsefulDefine
//
//  Created by pi on 16/3/3.
//  Copyright © 2016年 pi. All rights reserved.
//  Ref : https://github.com/bennyguitar/Colours/blob/master/Colours.m
//

#import <UIKit/UIKit.h>

static inline UIColor * UIColorWithRGBA(CGFloat r,CGFloat g, CGFloat b, CGFloat a){
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)];
}

static inline UIColor * UIClearColor(){
    return [UIColor clearColor];
}

@interface UIColor (Addition)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
- (NSString *)hexString;
+ (UIColor *)UIColorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;
@end
