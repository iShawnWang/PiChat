//
//  AudioRecorderController.m
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AudioRecorderController.h"
#import "CommenUtil.h"

@import AVFoundation;

@interface AudioRecorderController ()<AVAudioRecorderDelegate>
@property (strong,nonatomic) AVAudioRecorder *recorder;
@property (strong,nonatomic) AVAudioPlayer *player;
@property (strong,nonatomic) NSTimer *timer;
@end

@implementation AudioRecorderController
-(AVAudioRecorder *)recorder{
    if(!_recorder){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];  //设置录音格式
        [dic setObject:@(8000) forKey:AVSampleRateKey];                 //设置采样率
        [dic setObject:@(1) forKey:AVNumberOfChannelsKey];              //设置通道，这里采用单声道
        [dic setObject:@(8) forKey:AVLinearPCMBitDepthKey];             //每个采样点位数，分为8，16，24，32
        [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        _recorder=[[AVAudioRecorder alloc]initWithURL:[self cacheFilePathUrl] settings:dic error:nil];
        _recorder.meteringEnabled=YES;
        _recorder.delegate=self;
    }
    return _recorder;
}

-(AVAudioPlayer *)player{
    if(!_player){
        _player=[[AVAudioPlayer alloc]initWithContentsOfURL:[self cacheFilePathUrl] error:nil];
    }
    return _player;
}
-(NSTimer *)timer{
    if(!_timer){
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateMetersView:) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(NSURL*)cacheFilePathUrl{
    NSString *cacheDir= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [NSURL fileURLWithPath:[cacheDir stringByAppendingPathComponent:@"baba.caf"]];
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)success{
    if(success){
        NSError *error;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
        [audioSession setActive:YES error:&error];
        //测试用 录音后立即播放 ~
//        [self.player play];
        [self.delegate audioRecorder:self didEndRecord:recorder.url];
    }else{
        [self.delegate audioRecorder:self didEndRecord:nil];
    }
}


-(void)updateMetersView:(NSTimer*)timer{
    [self.recorder updateMeters];
    CGFloat power= [self.recorder averagePowerForChannel:0];
    [self.delegate audioRecorder:self updateSoundLevel:power];
}


#pragma mark - Record

- (void)startRecord {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    [audioSession setActive:YES error:&error];
    if(error){
        NSLog(@"%@",error);
        return;
    }
    self.timer.fireDate=[NSDate distantPast];
    [self.recorder record];
}

- (void)endRecord {
    self.timer.fireDate=[NSDate distantFuture];
    [self.recorder stop];
}

@end