//
//  InputContentView.m
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "InputContentView.h"
#import <Masonry.h>

@interface InputContentView ()
@property (strong,nonatomic) UIButton *audioTextSwitchBtn;
@property (assign,nonatomic) BOOL isTextInput;
@property (strong,nonatomic) UIButton *recordBtn;
@end

@implementation InputContentView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.isTextInput=YES;
    [self.leftBarButtonContainerView addSubview:self.audioTextSwitchBtn];
    [self.textView.superview insertSubview:self.recordBtn belowSubview:self.textView];
}

-(UIButton *)audioTextSwitchBtn{
    if(!_audioTextSwitchBtn){
        _audioTextSwitchBtn=[UIButton buttonWithType:UIButtonTypeContactAdd];
        [_audioTextSwitchBtn addTarget:self action:@selector(toggleAudioTextInput) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioTextSwitchBtn;
}

-(UIButton *)recordBtn{
    if(!_recordBtn){
        _recordBtn=[UIButton buttonWithType:UIButtonTypeInfoDark];
        [_recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

-(void)startRecord{
    self.recordBlock(YES);
}

-(void)endRecord{
    self.recordBlock(NO);
}

-(void)toggleAudioTextInput{
    self.isTextInput=!self.isTextInput;
    [UIView animateWithDuration:0.25 animations:^{
        self.textView.alpha=self.isTextInput ? 1.0 :0.0;
        self.recordBtn.alpha=self.isTextInput ? 0.0 :1.0;
    } completion:^(BOOL finished) {
        
    }];
}


/**
 *  这自定义真要命 ~ 作者还不给开发自定义的 API, 555
 */
-(void)decorateView{
    [self.leftBarButtonContainerView addSubview:self.audioTextSwitchBtn];
    self.leftBarButtonItemWidth=66;
    
    for (NSLayoutConstraint *constraint in self.leftBarButtonItem.superview.constraints) {
        if(constraint.secondItem ==self.leftBarButtonItem &&constraint.firstAttribute ==NSLayoutAttributeLeading){
            constraint.active=NO;
        }
    }
    
    [self.leftBarButtonItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
    }];
    
    [self.audioTextSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioTextSwitchBtn.superview.mas_top);
        make.bottom.equalTo(self.audioTextSwitchBtn.superview.mas_bottom);
        make.left.equalTo(self.leftBarButtonContainerView.mas_left);
        make.width.equalTo(@30);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView);
    }];
    
    [self.superview layoutIfNeeded];
}
@end
