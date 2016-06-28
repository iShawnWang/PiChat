//
//  PiReachability.m
//  PiChat
//
//  Created by pi on 16/6/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "PiReachability.h"

@implementation PiReachability
- (instancetype)init
{
    self = [super init];
    if (self) {
        GLobalRealReachability.hostForPing=@"www.baidu.com";
    }
    return self;
}

+(void)startNotifier{
    [GLobalRealReachability startNotifier];
}

+(void)stopNotifier{
    [GLobalRealReachability stopNotifier];
}
@end
