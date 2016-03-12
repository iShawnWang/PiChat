//
//  UIImage+ScaleSize.m
//  PiChat
//
//  Created by pi on 16/3/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UIImage+ScaleSize.h"

@implementation UIImage (ScaleSize)
-(UIImage*)scaledImageToSize:(CGSize)size{
    CGRect newImageRect= CGRectMake(0, 0, size.width, size.height);
    UIImage *scaledImg;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(),kCGInterpolationHigh);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, newImageRect);
    
    [self drawInRect:newImageRect];
    scaledImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImg;
}
@end
