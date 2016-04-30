//
//  ReplyInputView.h
//  PiChat
//
//  Created by pi on 16/4/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstant.h"

@interface ReplyInputView : UIView
@property (copy,nonatomic) StringResultBlock replyCommentCallback;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

+(instancetype)loadViewFromXib;
-(void)showInViewAtBottom:(UIView*)v;

-(void)observeKeyboardDisplay;
-(void)unobserveKeyboardDisplay;
@end
