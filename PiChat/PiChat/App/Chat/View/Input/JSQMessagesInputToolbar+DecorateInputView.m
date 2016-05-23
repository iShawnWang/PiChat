//
//  JSQMessagesInputToolbar+DecorateInputView.m
//  PiChat
//
//  Created by pi on 16/3/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "JSQMessagesInputToolbar+DecorateInputView.h"

@implementation JSQMessagesInputToolbar (DecorateInputView)

/**
 *  加载我们自定义的 InputContentView
 *
 *  @param JSQMessagesToolbarContentView
 *
 *  @return 
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
-(JSQMessagesToolbarContentView *)loadToolbarContentView{
    return [[[NSBundle mainBundle]loadNibNamed:@"InputContentView" owner:nil options:nil]firstObject];
}
#pragma clang diagnostic pop


@end
