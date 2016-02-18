//
//  LeanCloudManager.h
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@interface LeanCloudManager : NSObject
+(void)setupApplication:(NSDictionary*)launchOptions;
+(void)showFeedBackIn:(UIViewController*)vc;
@end
