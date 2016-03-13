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
-(UIImage*)findOrFetchImageFormUrl:(NSString*)urlStr;
@end
