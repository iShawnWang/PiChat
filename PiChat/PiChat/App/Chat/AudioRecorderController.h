//
//  AudioRecorderController.h
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstant.h"

@class AudioRecorderController;
@protocol AudioRecorderDelegate <NSObject>

-(void)audioRecorder:(AudioRecorderController*)recorder didEndRecord:(NSURL*)audio;
-(void)audioRecorder:(AudioRecorderController *)recorder updateSoundLevel:(CGFloat)level;
@end

/**
 *  录音管理.
 */
@interface AudioRecorderController : NSObject
@property(nonatomic,weak) IBOutlet id<AudioRecorderDelegate> delegate;
- (void)startRecord;
- (void)endRecord;

/**
 *  获取音频文件的时长
 *
 *  @param audioUrl
 *
 *  @return
 */
+(NSTimeInterval)durationForAudioFile:(NSURL*)audioUrl;
@end
