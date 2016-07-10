//
//  ImageCache.h
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageClipConfiguration.h"
#import "NSNotification+DownloadImage.h"
@class UIImage;
@class ImageClipConfiguration;

/**
 *  图片缓存,基于 SDW
 */
@interface ImageCache : NSObject
+(instancetype)sharedImageCache;

-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr;

/**
 *  获取 url 对应的图片.如果缓存中有图片,返回图片.如果没有,立即返回 nil.
 *
 *  @param urlStr
 *  @param clipConfig 下载完图片后执行裁剪,圆角,缩放等操作.从缓存中拿图片则不执行这个操作
 *
 *  @return
 */
-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr withImageClipConfig:(ImageClipConfiguration*)clipConfig;
@end
