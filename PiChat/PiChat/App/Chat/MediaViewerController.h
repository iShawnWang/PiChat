//
//  MediaViewerController.h
//  PiChat
//
//  Created by pi on 16/2/15.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;

/**
 *  媒体浏览,图片,视频,位置等.
 */
@interface MediaViewerController : NSObject
+(void)showIn:(UIViewController*)controller withImage:(UIImage*)img ;
+(void)showIn:(UIViewController *)controller withImageUrl:(NSURL*)imgUrl;
+(void)showIn:(UIViewController*)controller withVideoUrl:(NSURL*)url;
+(void)showIn:(UIViewController *)controller withLocation:(CLLocation *)location;
@end
