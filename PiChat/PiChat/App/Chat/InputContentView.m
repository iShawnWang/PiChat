//
//  InputContentView.m
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "InputContentView.h"
#import <Masonry.h>
#import "AGEmojiKeyBoardView.h"
#import "CommenUtil.h"


@interface InputContentView ()<AGEmojiKeyboardViewDelegate,AGEmojiKeyboardViewDataSource>
@property (strong,nonatomic) UIButton *audioTextSwitchBtn;
@property (assign,nonatomic) BOOL isTextInput;
@property (strong,nonatomic) UIButton *recordBtn;
@property (strong,nonatomic) AGEmojiKeyboardView *emojiKeyboard;

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
        _audioTextSwitchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioTextSwitchBtn addTarget:self action:@selector(toggleAudioTextInput) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioTextSwitchBtn;
}

-(UIButton *)recordBtn{
    if(!_recordBtn){
        _recordBtn=[[UIButton alloc]init];
        [_recordBtn setTitle:@"按住说话" forState: UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

-(InputAttachmentView *)inputAttachmentView{
    if(!_inputAttachmentView){
        _inputAttachmentView=[InputAttachmentView loadFromNib];
    }
    return _inputAttachmentView;
}

-(AGEmojiKeyboardView *)emojiKeyboard{
    if(!_emojiKeyboard){
        _emojiKeyboard=[[AGEmojiKeyboardView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216) dataSource:self];
        _emojiKeyboard.delegate=self;
        _emojiKeyboard.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _emojiKeyboard;
}

-(void)startRecord{
    self.recordBlock(YES);
}

-(void)endRecord{
    self.recordBlock(NO);
}

-(void)toggleAudioTextInput{
    self.audioTextSwitchBtn.selected=!self.audioTextSwitchBtn.selected;
    self.isTextInput=!self.isTextInput;
    [UIView animateWithDuration:0.25 animations:^{
        self.textView.alpha=self.isTextInput ? 1.0 :0.0;
        self.recordBtn.alpha=self.isTextInput ? 0.0 :1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    if(self.isTextInput){
        self.textView.inputView=nil;
        [self.textView becomeFirstResponder];
        [self.textView reloadInputViews];
    }else{
        self.textView.inputView=nil;
        [self.textView resignFirstResponder];
    }
    
}

-(void)toggleAttachmentKeyBoard{
    if([self.textView.inputView isKindOfClass:[InputAttachmentView class]]){
        self.textView.inputView=nil;
        [self.textView resignFirstResponder];
    }else{
        self.textView.inputView = self.inputAttachmentView;
        [self.textView becomeFirstResponder];
        [self.textView reloadInputViews];
    }
}

-(void)toggleEmojiKeyBoard{
    if([self.textView.inputView isKindOfClass:[AGEmojiKeyboardView class]]){
        self.textView.inputView=nil;
    }else{
        self.textView.inputView = self.emojiKeyboard;
    }
    [self.textView reloadInputViews];
}

#pragma mark - Emoji
-(void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji{
    self.textView.text = [self.textView.text stringByAppendingString:emoji];
    //hack here
    JSQMessagesInputToolbar *inputToolbar= (JSQMessagesInputToolbar*)self.superview;
    [inputToolbar toggleSendButtonEnabled];
}

-(void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView{
    //TODO 删除需要按2次才能删除表情,表情不是 attributeString, 是2个字符大小的文字 !~
    if(self.textView.text.length>0){
        NSRange lastStrRange=NSMakeRange(self.textView.text.length-1, 1);
        self.textView.text=[self.textView.text stringByReplacingCharactersInRange:lastStrRange withString:@""];
    }
}

-(AGEmojiKeyboardViewCategoryImage)defaultCategoryForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView{
    return AGEmojiKeyboardViewCategoryImageFace;
}

#pragma mark -
-(UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category{
    //TODO text 改文字
    return [UIImage new];
}

-(UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category{
    return [UIImage new];
}

-(UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView{
    return [UIImage imageNamed:@"backImg"];
}

-(UIImage*)textToImage:(NSString*)text{
    return [CommenUtil textToImage:text size:CGSizeMake(30, 10)];
}



/**
 *  这自定义真要命 ~ 作者还不给开发自定义的 API, 555
 */
-(void)decorateView{
    //自定义图片
    UIImage *voiceImg = [UIImage imageNamed:@"chat_voice"];
    UIImage *chatImg=[UIImage imageNamed:@"chat_text"];
    
    UIImage *addImg = [UIImage imageNamed:@"chat_add"];
    
    
    [self.leftBarButtonItem setImage:addImg forState:UIControlStateNormal];
    [self.leftBarButtonItem setImage:addImg forState:UIControlStateHighlighted];
    
    [self.audioTextSwitchBtn setImage:chatImg forState:UIControlStateSelected];
    [self.audioTextSwitchBtn setImage:voiceImg forState:UIControlStateNormal];
    
    //
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
