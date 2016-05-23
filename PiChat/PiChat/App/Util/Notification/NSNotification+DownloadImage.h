//
//  NSNotification+DownloadImage.h
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

extern NSString *const kDownloadImageCompleteNotification;

/**
 *  ImageCache 下载完图片通知
 */
@interface NSNotification (DownloadImage)
@property (strong,nonatomic,readonly) UIImage *image;
@property (strong,nonatomic,readonly) NSURL *imageUrl;

+(void)postDownloadImageNotification:(id)object image:(UIImage*)img url:(NSURL*)imageUrl;
@end
