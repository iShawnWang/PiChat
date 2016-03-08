//
//  AudioRecorderController.m
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AudioRecorderController.h"
#import "CommenUtil.h"
#import "GlobalConstant.h"
@import AVFoundation;

@interface AudioRecorderController ()<AVAudioRecorderDelegate>
@property (strong,nonatomic) AVAudioRecorder *recorder;
@property (strong,nonatomic) AVAudioPlayer *player;
@property (copy,nonatomic) UrlResultBlock callback;
@end

@implementation AudioRecorderController
-(AVAudioRecorder *)recorder{
    if(!_recorder){
        NSString *audioPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.caf"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];  //设置录音格式
        [dic setObject:@(8000) forKey:AVSampleRateKey];                 //设置采样率
        [dic setObject:@(1) forKey:AVNumberOfChannelsKey];              //设置通道，这里采用单声道
        [dic setObject:@(8) forKey:AVLinearPCMBitDepthKey];             //每个采样点位数，分为8，16，24，32
        [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        _recorder=[[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:audioPath] settings:dic error:nil];
        _recorder.delegate=self;
    }
    return _recorder;
}

-(AVAudioPlayer *)player{
    if(!_player){
        NSString *audioPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.caf"];
        _player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:audioPath] error:nil];
    }
    return _player;
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)success{
    if(success){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        self.callback(recorder.url,nil);
        [self.player play];
    }else{
        self.callback(nil,nil);
    }
}

#pragma mark - Record

- (void)startRecord {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [self.recorder record];
}

- (void)endRecord {
    [self.recorder stop];
}

@end
