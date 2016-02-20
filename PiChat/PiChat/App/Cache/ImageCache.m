//
//  ImageCache.m
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ImageCache.h"
#import <SDWebImageManager.h>

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

-(void)downloadAndCacheImageInBackGround:(NSString*)urlStr{
    [self.manager downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
}

/**
 *  同步(阻塞) 在当前线程中 返回缓存的图片
 *
 *  @param urlStr
 *
 *  @return
 */
-(UIImage*)imageFromCacheForUrl:(NSString*)urlStr{
    UIImage *img;
    NSString *cacheKey=[self.manager cacheKeyForURL:[NSURL URLWithString:urlStr]];
    
    //从内存缓存中查找图片,没有就从硬盘缓存中找..
    img=[self.manager.imageCache imageFromDiskCacheForKey:cacheKey];
    
    if(!img){//在没有就下载,
        [self downloadAndCacheImageInBackGround:urlStr];
    }
    //立即返回 nil,不等下载完
    return img;
}
@end
