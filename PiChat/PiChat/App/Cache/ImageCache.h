//
//  ImageCache.h
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface ImageCache : NSObject
+(instancetype)sharedImageCache;
-(void)downloadAndCacheImageInBackGround:(NSString*)urlStr;
-(UIImage*)imageFromCacheForUrl:(NSString*)urlStr;
@end
