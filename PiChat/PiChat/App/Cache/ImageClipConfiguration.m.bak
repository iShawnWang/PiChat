//
//  ImageClipConfiguration.m
//  PiChat
//
//  Created by pi on 16/4/26.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ImageClipConfiguration.h"
#import "UIImage+Resizing.h"
#import "UIImage+ClipRoundCorner.h"

@implementation ImageClipConfiguration

+(instancetype)configurationWithFitViewSize:(CGSize)fitSize{
    return [ImageClipConfiguration configurationWithFitViewSize:fitSize circleImage:NO];
}

+(instancetype)configurationWithFitViewSize:(CGSize)fitSize circleImage:(BOOL)isCircle{
    NSInteger radius=isCircle ? MAX(fitSize.width, fitSize.height) : 0;
    return [ImageClipConfiguration configurationWithFitViewSize:fitSize cornerRadius:radius isCircle:isCircle];
}

+(instancetype)configurationWithFitViewSize:(CGSize)fitSize cornerRadius:(NSInteger)radius isCircle:(BOOL)isCircle{
    ImageClipConfiguration *configuration=[ImageClipConfiguration new];
    configuration.fitViewSize=fitSize;
    configuration.cornerRadius=radius;
    configuration.isCircle=isCircle;
    return configuration;
}

+(instancetype)configurationWithCornerRadius:(NSInteger)radius{
    return [ImageClipConfiguration configurationWithFitViewSize:CGSizeZero cornerRadius:radius isCircle:NO];
}

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
            
            transformedImg= [self scaleToFitSize:configuration.fitViewSize];
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


