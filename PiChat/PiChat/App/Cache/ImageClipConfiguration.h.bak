//
//  ImageClipConfiguration.h
//  PiChat
//
//  Created by pi on 16/4/26.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ImageClipConfiguration : NSObject
@property (assign,nonatomic) NSInteger cornerRadius;
@property (assign,nonatomic) CGSize fitViewSize;
@property (assign,nonatomic) BOOL isCircle;

/**
 *  缩放图片到指定大小
 *
 *  @param fitSize
 *
 *  @return
 */
+(instancetype)configurationWithFitViewSize:(CGSize)fitSize;

/**
 *  只添加指定大小的圆角
 *
 *  @param radius
 *
 *  @return
 */
+(instancetype)configurationWithCornerRadius:(NSInteger)radius;

/**
 *  缩放图片到指定大小 ,并裁剪为圆形
 *
 *  @param fitSize
 *  @param isCircle
 *
 *  @return
 */
+(instancetype)configurationWithFitViewSize:(CGSize)fitSize circleImage:(BOOL)isCircle;

/**
 *  裁剪为圆形图片,不改变大小
 *
 *  @param isCircle
 *
 *  @return
 */
+(instancetype)configurationWithCircleImage:(BOOL)isCircle;

/**
 *  缩放图片到指定大小,添加指定大小的圆角
 *
 *  @param fitSize
 *  @param radius
 *
 *  @return
 */
+(instancetype)configurationWithFitViewSize:(CGSize)fitSize cornerRadius:(NSInteger)radius isCircle:(BOOL)isCircle;
@end


@interface UIImage (TransformWithConfiguration)
-(instancetype)transformWithConfiguration:(ImageClipConfiguration*)configuration;
@end