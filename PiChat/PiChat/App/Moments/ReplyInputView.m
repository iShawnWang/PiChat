//
//  ReplyInputView.m
//  PiChat
//
//  Created by pi on 16/4/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ReplyInputView.h"
#import <Masonry.h>
#import "CommenUtil.h"

@interface ReplyInputView ()

@end

@implementation ReplyInputView

+(instancetype)loadViewFromXib{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ReplyInputView class]) owner:nil options:nil]firstObject];
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self.textField becomeFirstResponder];
}

- (IBAction)sendReplyComment:(id)sender {
    NSString *reply=[self.textField.text trim];
    if(reply && reply.length>0){
        self.replyCommentCallback(reply,nil);
    }
}

-(void)pinToViewBottom:(UIView*)view{
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view);
        make.bottom.equalTo(view);
    }];
    
    [self.superview updateConstraintsIfNeeded];
}

-(void)showInViewAtBottom:(UIView *)v{
    [v addSubview:self];
    [self pinToViewBottom:v];
    [self.textField becomeFirstResponder];
}

#pragma mark - Keyboard 和键盘一起移动
-(void)observeKeyboardDisplay{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)unobserveKeyboardDisplay{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)handleKeyboardShow:(NSNotification*)noti{
    if(!self.superview){
        return;
    }
    NSTimeInterval duration= [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    CGRect endRect= [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform=CGAffineTransformMakeTranslation(0, -CGRectGetHeight(endRect));
    } completion:nil];
    
}

-(void)handleKeyboardHide:(NSNotification*)noti{
    if(!self.superview){
        return;
    }
    NSTimeInterval duration= [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
