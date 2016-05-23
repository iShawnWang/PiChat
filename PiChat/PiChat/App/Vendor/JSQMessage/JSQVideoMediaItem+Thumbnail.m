//
//  JSQVideoMediaItem+Thumbnail.m
//  PiChat
//
//  Created by pi on 16/3/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "JSQVideoMediaItem+Thumbnail.h"
#import <objc/runtime.h>
#import "UIImage+Resizing.h"
@import AVFoundation;

NSString *const kCacheVideoImageView=@"cachedVideoImageView";

@implementation JSQVideoMediaItem (Thumbnail)

/**
 *  在这个 Category 中, Override 了 `mediaView` 方法.
 *  显示视频 Cell 的缩略图
 *
 *  @return
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (UIView *)mediaView
{
    if (self.fileURL == nil || !self.isReadyToPlay) {
        return nil;
    }
    UIImageView *cachedVideoImageView=[self valueForKey:kCacheVideoImageView];
    if (cachedVideoImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIImage *playIcon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
        
        UIImage *thumbnailImg=[JSQVideoMediaItem thumbnailFromVideoAtURL:self.fileURL];
        UIImageView *imageView;
        
        if (thumbnailImg) {
            UIImageView * iconView = [[UIImageView alloc] initWithImage:playIcon];
            iconView.backgroundColor = [UIColor clearColor];
            iconView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
            iconView.contentMode = UIViewContentModeCenter;
            iconView.clipsToBounds = YES;
            
            UIImage *scaledThumbnailImg=[thumbnailImg scaleToFitSize:size];
            imageView = [[UIImageView alloc] initWithImage:scaledThumbnailImg];
            [imageView addSubview:iconView];
        } else {
            imageView = [[UIImageView alloc] initWithImage:playIcon];
        }
        
        imageView.backgroundColor = [UIColor blackColor];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeCenter;
        imageView.clipsToBounds = YES;
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        [self setValue:imageView forKey:kCacheVideoImageView];
    }
    return [self valueForKey:kCacheVideoImageView];
}
#pragma clang diagnostic pop

+ (UIImage *)thumbnailFromVideoAtURL:(NSURL *)contentURL {
    UIImage *theImage = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(5,60);
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    
    theImage = [[UIImage alloc] initWithCGImage:imgRef];
    
    CGImageRelease(imgRef);
    
    return theImage;
}
@end
