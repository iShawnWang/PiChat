//
//  LogManager.h
//  PiChat
//
//  Created by pi on 16/7/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack.h>

static const DDLogLevel ddLogLevel =
#ifdef DEBUG
DDLogLevelDebug;
#else
DDLogLevelError;
#endif

@interface LogManager : NSObject

@end
