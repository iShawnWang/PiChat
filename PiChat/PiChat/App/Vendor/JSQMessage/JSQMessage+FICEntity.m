//
//  JSQMessage+FICEntity.m
//  PiChat
//
//  Created by pi on 16/7/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "JSQMessage+FICEntity.h"
#import "GlobalConstant.h"
#import "JSQPhotoMediaItem+ThumbnailImageUrl.h"
#import "JSQMessage+MessageID.h"
#import "UIImage+Resizing.h"

NSString *const kJSQMessageFamily=kBundleID @"kJSQMessageFamily";
NSString *const kJSQMessagePhotoItemFormatName= kBundleID @"kJSQMessagePhotoItemFormatName";

const CGSize kJSQMessagePhotoItemImageSizePhone={210.0f, 150.0f};
const CGSize kJSQMessagePhotoItemImageSizePad={315.0f, 225.0f};

@implementation JSQMessage (FICEntity)
-(NSString *)FIC_UUID{
    if(!self.messageID){
        return nil;
    }
    NSString *uuid=MD5HashFromString(self.messageID);
    return uuid;
}

-(NSString *)FIC_sourceImageUUID{
    if([self.media isKindOfClass:[JSQPhotoMediaItem class]]){
        return MD5HashFromString(((JSQPhotoMediaItem*)self.media).thumbnailImageUrl);
    }
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"FastImageCache 只缓存 JSQPhotoMediaItem 的图片,先检查 media 的类型再用 ImageCacheManager 获取图片" userInfo:nil];
}

-(NSURL *)FIC_sourceImageURLWithFormatName:(NSString *)formatName{
    return [NSURL URLWithString:((JSQPhotoMediaItem*)self.media).thumbnailImageUrl];
}

-(FICEntityImageDrawingBlock)FIC_drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName{
    FICEntityImageDrawingBlock drawingBlock =^(CGContextRef contextRef, CGSize contextSize){
        //缩放图片
        if([formatName isEqualToString:kJSQMessagePhotoItemFormatName]){
            UIImage *processedImage=[image scaleToFitSize:contextSize];
            UIGraphicsPushContext(contextRef);
            [processedImage drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
            UIGraphicsPopContext();
        }else{
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@" kJSQMessagePhotoItemFormatName 别填错了 ~" userInfo:nil];
        }
    };
    
    return drawingBlock;
}
@end
