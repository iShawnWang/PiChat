//
//  RecordIndocator.m
//  PiChat
//
//  Created by pi on 16/3/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "RecordIndocator.h"

@interface RecordIndocator ()
@end

@implementation RecordIndocator

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self privateInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self privateInit];
    }
    return self;
}

-(void)privateInit{
    self.layer.cornerRadius=8;
    self.waveColor=[UIColor whiteColor];
    self.primaryWaveLineWidth=3.0f;
    self.secondaryWaveLineWidth=1.0f;
}

- (CGFloat)normalizedPowerLevelFromDecibels:(CGFloat)decibels{
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    CGFloat level=powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
    return level;
}
@end
