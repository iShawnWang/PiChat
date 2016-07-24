//
//  User+FICEntity.m
//  PiChat
//
//  Created by pi on 16/7/10.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "User+FICEntity.h"
#import "UIImage+Resizing.h"
#import "UIImage+GaussianBlur.h"
#import "UIImage+ClipRoundCorner.h"

NSString *const kUserAvatarFamily= kBundleID @"kUserAvatarFamily";
NSString *const kUserAvatarOriginalFormatName= kBundleID @"kUserAvatarOriginalFormatName";
NSString *const kUserAvatarBlurFormatName= kBundleID @"kUserAvatarBlurFormatName";
NSString *const kUserAvatarRoundFormatName= kBundleID @"kUserAvatarRoundFormatName";

const CGSize kUserAvatarOriginalImageSize={198,198};
const CGSize kUserAvatarBlurImageSize={198,198};
const CGSize kUserAvatarRoundImageSize={84,84};


@interface User ()

@end

@implementation User (FICEntity)

-(NSString *)FIC_UUID{
    if(!self.objectId){
        return nil;
    }
    
    NSString *uuid=MD5HashFromString(self.objectId);
    return uuid;
}

-(NSString *)FIC_sourceImageUUID{
    return MD5HashFromString(self.avatarPath);
}

-(NSURL *)FIC_sourceImageURLWithFormatName:(NSString *)formatName{
    return [NSURL URLWithString:self.avatarPath];
}

-(FICEntityImageDrawingBlock)FIC_drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName{
    FICEntityImageDrawingBlock drawingBlock =^(CGContextRef contextRef, CGSize contextSize){
        //缩放图片
        UIImage *processedImage=[image scaleToFitSize:contextSize];
        if([formatName isEqualToString:kUserAvatarOriginalFormatName]){
            //圆角
            processedImage=[processedImage clipToCircleImage];
        }else if([formatName isEqualToString:kUserAvatarBlurFormatName]){
            //模糊
            processedImage=[UIImage imageWithData:UIImageJPEGRepresentation(processedImage, 1.0)]; //remove alpha channel
            processedImage=[processedImage vImageBlurWithNumber:0.2];
        }else if([formatName isEqualToString:kUserAvatarRoundFormatName]){
            //圆角
            processedImage=[processedImage clipToCircleImage];
        }
        UIGraphicsPushContext(contextRef);
        [processedImage drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
        UIGraphicsPopContext();
    };
    
    return drawingBlock;
}
@end
