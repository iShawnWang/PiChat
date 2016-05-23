//
//  InputContentView.h
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "GlobalConstant.h"
#import "InputAttachmentView.h"
@class InputAttachmentView;

typedef void (^RecordBlock)(BOOL startRecord);

/**
 *  自定义 JSQMessageController 的输入 Toolbar, 全写在 ViewController 的 ViewDidload 里有点乱,放在这个 Category 里了..
 */
@interface InputContentView : JSQMessagesToolbarContentView

/**
 *  开始或者结束录音时调用这个 Block, 可以在 Block 里显示或者隐藏,提示用户录音状态的 View
 */
@property (copy,nonatomic) RecordBlock recordBlock;
@property (strong,nonatomic) InputAttachmentView *inputAttachmentView;

/**
 *  在 ViewDidLoad 方法调用一下这个...来自定义 Toolbar, 作者不提供自定义的 API... 没整..
 */
-(void)decorateView;

/**
 *  
 */
-(void)toggleAttachmentKeyBoard;
-(void)toggleEmojiKeyBoard;
@end
