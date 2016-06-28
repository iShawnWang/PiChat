//
//  AutoPurgeCache.m
//  PiChat
//
//  Created by pi on 16/3/13.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "PiAutoPurgeCache.h"
@import UIKit;

@implementation PiAutoPurgeCache
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}
@end
