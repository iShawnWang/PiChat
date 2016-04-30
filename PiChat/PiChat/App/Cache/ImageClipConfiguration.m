//
//  ImageClipConfiguration.m
//  PiChat
//
//  Created by pi on 16/4/26.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ImageClipConfiguration.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ClipRoundCorner.h"

@implementation ImageClipConfiguration

/**
 *  缩放图片到指定大小
 *
 *  @param fitSize
 *
 *  @return
 */
+(instancetype)configurationWithFitViewSize:(CGSize)fitSize{
    return [ImageClipConfiguration configurationWithFitViewSize:fitSize circleImage:NO];
}

/**
 *  缩放图片到指定大小 ,并裁剪为圆形
 *
 *  @param fitSize
 *  @param isCircle
 *
 *  @return
 */
+(instancetype)configurationWithFitViewSize:(CGSize)fitSize circleImage:(BOOL)isCircle{
    NSInteger radius=isCircle ? MAX(fitSize.width, fitSize.height) : 0;
    return [ImageClipConfiguration configurationWithFitViewSize:fitSize cornerRadius:radius isCircle:isCircle];
}


/**
 *  缩放图片到指定大小,添加指定大小的圆角
 *
 *  @param fitSize
 *  @param radius
 *
 *  @return
 */
+(instancetype)configurationWithFitViewSize:(CGSize)fitSize cornerRadius:(NSInteger)radius isCircle:(BOOL)isCircle{
    ImageClipConfiguration *configuration=[ImageClipConfiguration new];
    configuration.fitViewSize=fitSize;
    configuration.cornerRadius=radius;
    configuration.isCircle=isCircle;
    return configuration;
}

/**
 *  只添加指定大小的圆角
 *
 *  @param radius
 *
 *  @return
 */
+(instancetype)configurationWithCornerRadius:(NSInteger)radius{
    return [ImageClipConfiguration configurationWithFitViewSize:CGSizeZero cornerRadius:radius isCircle:NO];
}

/**
 *  裁剪为圆形图片,不改变大小
 *
 *  @param isCircle
 *
 *  @return
 */
+(instancetype)configurationWithCircleImage:(BOOL)isCircle{
    return [ImageClipConfiguration configurationWithFitViewSize:CGSizeZero circleImage:isCircle];
}
@end

/**
 *  根据 TransformWithConfiguration 处理图片圆角和缩放
 */
@implementation UIImage (TransformWithConfiguration)
-(instancetype)transformWithConfiguration:(ImageClipConfiguration *)configuration{
    
    if(configuration && ![configuration isEqual:[NSNull null]]){
        UIImage *transformedImg;
        if(!CGSizeEqualToSize(CGSizeZero, configuration.fitViewSize)){
            transformedImg= [self scaledImageToSize:configuration.fitViewSize];
        }
        if(configuration.cornerRadius>0){
            transformedImg= [self clipRoundCornerWithRadius:configuration.cornerRadius];
        }
        if(configuration.isCircle){
            transformedImg= [self clipRoundCornerWithRadius:MAX(self.size.width, self.size.height)];
        }
        return transformedImg;
    }
    return self;
}
@end


