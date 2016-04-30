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

@interface ImageCache ()<SDWebImageManagerDelegate>
@property (strong,nonatomic) SDWebImageManager *manager;
@property (strong,nonatomic) NSMutableDictionary *downloadingImages;
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
        _manager.delegate=self;
    }
    return _manager;
}

-(NSMutableDictionary *)downloadingImageUrlStrs{
    if(!_downloadingImages){
        _downloadingImages=[NSMutableDictionary dictionary];
    }
    return _downloadingImages;
}

#pragma mark - Public

-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr{
    return [self findOrFetchImageFormUrl:urlStr withImageClipConfig:nil];
}

/**
 *  不会阻塞,先查询内存缓存,如果存在图片直接返回,否则开始下载,返回 [UIImage new];
 *  下载后剪切圆角,生成一张新图片存到缓存中 ~
 *
 *  @param urlStr 
 *
 *  @return
 */
-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr withImageClipConfig:(ImageClipConfiguration*)clipConfig{
    __block UIImage *img;
    if(!urlStr){
        return [UIImage new];
    }
    
    NSURL *theImgUrl=[NSURL URLWithString:urlStr];
    
    
    //先从内存缓存中找图片,没有就交给 SDW 从磁盘缓存中再找,在没有就下载.
    SDImageCache *cache=self.manager.imageCache;
    img= [cache imageFromMemoryCacheForKey:[self.manager cacheKeyForURL:theImgUrl]];
    if(img){
        return img;
    }
    
    //防止重复下载,先看看是否已经正在下载这个图片了
    //其实 SDW 内部做了这个防止重复下载的操作,这里我们为了不让它发送多次下载图片完成的通知.
    if([self.downloadingImageUrlStrs.allKeys containsObject:urlStr]){
        return [UIImage new];
    }
    
    [self.downloadingImageUrlStrs setObject:clipConfig ? : [NSNull null] forKey:urlStr];
    
    //内存缓存中没有图片,开始从硬盘缓存中查找图片,再没有就异步下载图片,马上返回一个空白图片 - [UIImage new]
    [self.manager downloadImageWithURL:theImgUrl options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self.downloadingImages removeObjectForKey:urlStr];
//        NSLog(@"下载图片 : %@ : %@ : %@",image,imageURL ,error);
        if(!error && finished && image && imageURL){
            [NSNotification postDownloadImageNotification:self image:image url:theImgUrl];
        }
    }];
    return [UIImage new];
}

#pragma mark - SDWebImageManagerDelegate
/**
 *  SDW 下载完图片后先处理一下圆角和图片大小,在存入缓存中
 *
 *  @param imageManager
 *  @param image
 *  @param imageURL
 *
 *  @return
 */
-(UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL{
    ImageClipConfiguration *configuration= [self.downloadingImages valueForKey:imageURL.absoluteString];
    UIImage *transformedImg=[image transformWithConfiguration:configuration];
    return transformedImg;
}

@end
