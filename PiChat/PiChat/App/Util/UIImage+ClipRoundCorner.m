//
//  UIImage+ClipRoundCorner.m
//
//  Created by pi on 16/4/26.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "UIImage+ClipRoundCorner.h"

@implementation UIImage (ClipRoundCorner)
-(instancetype)clipRoundCornerWithRadius:(NSInteger)radius size:(CGSize)size{
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    UIBezierPath *path= [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *roundCornerImg= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundCornerImg;
}

-(instancetype)clipRoundCornerWithRadius:(NSInteger)radius{
    return [self clipRoundCornerWithRadius:radius size:self.size];
}
@end
