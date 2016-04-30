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

@interface ImageCache : NSObject
+(instancetype)sharedImageCache;

-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr;
-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr withImageClipConfig:(ImageClipConfiguration*)clipConfig;
@end
