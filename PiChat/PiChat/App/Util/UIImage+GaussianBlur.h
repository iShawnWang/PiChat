//
//  UIImage+GaussianBlur.h
//  BlurDemo
//
//  Created by pi on 16/7/3.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GaussianBlur)
-(UIImage *)vImageBlurWithNumber:(CGFloat)blur;
-(UIImage *)coreBlurWithNumber:(CGFloat)blur;
@end
