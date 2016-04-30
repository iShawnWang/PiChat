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

+(instancetype)configurationWithFitViewSize:(CGSize)fitSize;

+(instancetype)configurationWithCornerRadius:(NSInteger)radius;

+(instancetype)configurationWithFitViewSize:(CGSize)fitSize circleImage:(BOOL)isCircle;

+(instancetype)configurationWithCircleImage:(BOOL)isCircle;

+(instancetype)configurationWithFitViewSize:(CGSize)fitSize cornerRadius:(NSInteger)radius isCircle:(BOOL)isCircle;
@end


@interface UIImage (TransformWithConfiguration)
-(instancetype)transformWithConfiguration:(ImageClipConfiguration*)configuration;
@end