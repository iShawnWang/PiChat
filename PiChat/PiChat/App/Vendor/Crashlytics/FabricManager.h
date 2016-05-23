//
//  FabricManager.h
//  PiChat
//
//  Created by pi on 16/5/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

/**
 *  Twitter 的 Fabric 的 Crashlytics
 */
@interface FabricManager : NSObject
+(void)setup;
+(void)setUserInfo;
@end
