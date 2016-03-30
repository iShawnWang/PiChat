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
@property (strong,nonatomic) NSMutableSet *downloadingImageUrlStrs;
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

-(NSMutableSet *)downloadingImageUrlStrs{
    if(!_downloadingImageUrlStrs){
        _downloadingImageUrlStrs=[NSMutableSet set];
    }
    return _downloadingImageUrlStrs;
}

/**
 *  不会阻塞,先查询硬盘内存缓存,如果存在图片直接返回,否则开始下载,返回 [UIImage new];
 *
 *  @param urlStr 
 *
 *  @return
 */
-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr{
    __block UIImage *img=[UIImage new];
    if(!urlStr){
        return img;
    }
    
    NSURL *theImgUrl=[NSURL URLWithString:urlStr];
    
    //先从内存缓存,然后硬盘缓存中取图片
    SDImageCache *cache=self.manager.imageCache;
    img=[cache imageFromDiskCacheForKey:[self.manager cacheKeyForURL:theImgUrl]];
    if(img){ //缓存中有图片就返回
        return img;
    }
    
    //防止重复下载,先看看是否已经正在下载这个图片了
    if([self.downloadingImageUrlStrs containsObject:urlStr]){
        return img;
    }
    
    [self.downloadingImageUrlStrs addObject:urlStr];
    
    //否则开始异步下载图片,马上返回一个空白图片 - [UIImage new]
    [self.manager downloadImageWithURL:theImgUrl options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self.downloadingImageUrlStrs removeObject:urlStr];
        if(!error && finished && image && imageURL){
            [NSNotification postDownloadImageNotification:self image:image url:theImgUrl];
        }
    }];
    return img;
}

@end
