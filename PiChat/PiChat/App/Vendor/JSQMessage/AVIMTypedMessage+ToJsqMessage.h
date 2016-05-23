//
//  AVIMTypedMessage+ToJsqMessage.h
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVIMTypedMessage.h"
#import "GlobalConstant.h"


@interface AVIMTypedMessage (ToJsqMessage)
/**
 *  转换 AVIMMessage 为 JSQMessage, 用来显示在 JSQMssageController 上
 *  转换过程可能会耗时,图片 Message, 语音 Message 等.应该在后台线程调用
 *
 *  @param callback
 */
-(void)toJsqMessageWithCallback:(JsqMsgBlock)callback;
@end
