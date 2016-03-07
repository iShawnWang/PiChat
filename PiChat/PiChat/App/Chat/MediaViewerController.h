//
//  MediaViewerController.h
//  PiChat
//
//  Created by pi on 16/2/15.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;

@interface MediaViewerController : NSObject
+(void)showIn:(UIViewController*)controller withImage:(UIImage*)img;
+(void)showIn:(UIViewController*)controller withVideoUrl:(NSURL*)url;
+(void)showIn:(UIViewController *)controller withLocation:(CLLocation *)location;
@end
