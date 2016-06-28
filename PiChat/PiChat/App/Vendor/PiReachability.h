//
//  PiReachability.h
//  PiChat
//
//  Created by pi on 16/6/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RealReachability.h>

@interface PiReachability : NSObject
+(void)startNotifier;
+(void)stopNotifier;
@end
