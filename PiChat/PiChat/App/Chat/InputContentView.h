//
//  InputContentView.h
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "GlobalConstant.h"

typedef void (^RecordBlock)(BOOL startRecord);

@interface InputContentView : JSQMessagesToolbarContentView
@property (copy,nonatomic) RecordBlock recordBlock;
-(void)decorateView;
@end
