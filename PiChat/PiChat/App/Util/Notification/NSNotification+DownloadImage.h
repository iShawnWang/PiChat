//
//  NSNotification+DownloadImage.h
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static NSString *const kDownloadImageCompleteNotification=@"kDownloadImageCompleteNotification";

@interface NSNotification (DownloadImage)
@property (strong,nonatomic,readonly) UIImage *image;
@property (strong,nonatomic,readonly) NSURL *imageUrl;

+(void)postDownloadImageNotification:(id)object image:(UIImage*)img url:(NSURL*)imageUrl;
@end
