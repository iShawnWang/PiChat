//
//  RecordIndocator.h
//  PiChat
//
//  Created by pi on 16/3/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCSiriWaveformView.h>

/**
 *  用波纹大小提示用户声音的大小
 */
@interface RecordIndocator : SCSiriWaveformView

/**
 *  根据 AVRecorder 的录音大小更新这个 View 的波纹大小
 *
 *  @param decibels
 *
 *  @return 
 */
- (CGFloat)normalizedPowerLevelFromDecibels:(CGFloat)decibels;
@end
