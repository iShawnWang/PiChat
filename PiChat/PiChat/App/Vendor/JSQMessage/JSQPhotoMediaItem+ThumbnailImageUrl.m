//
//  JSQPhotoMediaItem+ThumbnailImageUrl.m
//  PiChat
//
//  Created by pi on 16/4/30.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "JSQPhotoMediaItem+ThumbnailImageUrl.h"
#import <objc/runtime.h>

static char const * const kThumbnailImageUrlKey="kThumbnailImageUrlKey";
static char const * const kOriginalImageUrlKey="kOriginalImageUrlKey";

@implementation JSQPhotoMediaItem (ThumbnailImageUrl)
-(NSString *)thumbnailImageUrl{
    return objc_getAssociatedObject(self, kThumbnailImageUrlKey);
}

-(void)setThumbnailImageUrl:(NSString *)thumbnailImageUrl{
    objc_setAssociatedObject(self, kThumbnailImageUrlKey, thumbnailImageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)originalImageUrl{
    return objc_getAssociatedObject(self, kOriginalImageUrlKey);
}
-(void)setOriginalImageUrl:(NSString *)originalImageUrl{
    objc_setAssociatedObject(self, kOriginalImageUrlKey, originalImageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
