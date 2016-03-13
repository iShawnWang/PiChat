//
//  ImageCache.m
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ImageCache.h"
#import <SDWebImageManager.h>
#import "GlobalConstant.h"

@interface ImageCache ()
@property (strong,nonatomic) SDWebImageManager *manager;
@end
@implementation ImageCache
+(instancetype)sharedImageCache{
    static id _imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCache=[ImageCache new];
    });
    return _imageCache;
}

-(SDWebImageManager *)manager{
    if(!_manager){
        _manager=[SDWebImageManager sharedManager];
    }
    return _manager;
}

/**
 *  不会阻塞,先查询硬盘内存缓存,如果存在图片直接返回,否则开始下载,返回 [UIImage new];
 *
 *  @param urlStr 
 *
 *  @return
 */
-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr{
    __block UIImage *img;
    SDImageCache *cache=self.manager.imageCache;
    img=[cache imageFromDiskCacheForKey:[self.manager cacheKeyForURL:[NSURL URLWithString:urlStr]]];
    if(img){ //缓存中有图片就返回
        return img;
    }
    //否则开始异步下载图片,马上返回一个空白图片 - [UIImage new]
    [self.manager downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self postDownloadImageCompleteNotification:image url:imageURL];
    }];
    return [UIImage new];
}

-(void)postDownloadImageCompleteNotification:(UIImage*)img url:(NSURL*)url{
    if(img && url){
        [[NSNotificationCenter defaultCenter]postNotificationName:kDownloadImageCompleteNotification object:self userInfo:@{kDownloadedImage:img,kDownloadedImageUrl:url}];
    }
}

@end
