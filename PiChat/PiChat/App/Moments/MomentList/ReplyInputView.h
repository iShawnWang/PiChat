//
//  ReplyInputView.h
//  PiChat
//
//  Created by pi on 16/4/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstant.h"

/**
 *  对某条朋友圈发表评论,或者回复某人的评论时,最下面的输入框.
 */
@interface ReplyInputView : UIView
@property (copy,nonatomic) StringResultBlock replyCommentCallback;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

+(instancetype)loadViewFromXib;

/**
 *  通过addSubView 添加到某个 View 中,然后调用下面的 `observeKeyboardDisplay` 方法监听键盘弹出通知,来跟随键盘移动
 *
 *  @param v 
 */
-(void)showInViewAtBottom:(UIView*)v;

-(void)observeKeyboardDisplay;
-(void)unobserveKeyboardDisplay;
@end
