//
//  AVFile+FICEntity.m
//  PiChat
//
//  Created by pi on 16/7/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVFile+FICEntity.h"
#import "UIImage+Resizing.h"

NSString *const kMomentFamily=kBundleID @"kMomentFamily";
NSString *const kMomentThumbnailFormatName=kBundleID @"kMomentThumbnailFormatName";

const CGSize kMomentThumbnailImageSize={66,66};

NSString *const kMomentPhotoCodingKey=@"kMomentPhotoCodingKey";

@implementation AVFile (FICEntity)

#pragma mark - FICEntity
-(NSString *)FIC_UUID{
    if(!self.objectId){
        return nil;
    }
    NSString *uuid=MD5HashFromString(self.objectId);
    return uuid;
}

-(NSString *)FIC_sourceImageUUID{
    NSString *hash= MD5HashFromString(self.url);
    return hash;
}

-(NSURL *)FIC_sourceImageURLWithFormatName:(NSString *)formatName{
    NSURL *url=[NSURL URLWithString:self.url];
    return url;
}

-(FICEntityImageDrawingBlock)FIC_drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName{
    if([formatName isEqualToString:kMomentThumbnailFormatName]){
        __block UIImage *processedImage=image;
        FICEntityImageDrawingBlock drawingBlock=^(CGContextRef contextRef, CGSize contextSize){
            processedImage=[image scaleToFitSize:contextSize];
            UIGraphicsPushContext(contextRef);
            [processedImage drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
            UIGraphicsPopContext();
        };
        return drawingBlock;
    }
    return nil;
}

@end
