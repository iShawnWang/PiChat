//
//  RecordIndocator.h
//  PiChat
//
//  Created by pi on 16/3/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCSiriWaveformView.h>
@interface RecordIndocator : SCSiriWaveformView
- (CGFloat)normalizedPowerLevelFromDecibels:(CGFloat)decibels;
@end
