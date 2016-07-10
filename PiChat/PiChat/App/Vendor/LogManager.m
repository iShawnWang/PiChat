//
//  LogManager.m
//  PiChat
//
//  Created by pi on 16/7/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "LogManager.h"

@implementation LogManager
+(void)load{
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    [[DDTTYLogger sharedInstance]setColorsEnabled:YES];
}
@end
