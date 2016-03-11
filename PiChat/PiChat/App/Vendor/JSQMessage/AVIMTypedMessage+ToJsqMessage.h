//
//  AVIMTypedMessage+ToJsqMessage.h
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVIMTypedMessage.h"
#import "GlobalConstant.h"

static NSString *const kVideoFormat=@"kVideoFormat";

@interface AVIMTypedMessage (ToJsqMessage)
-(void)toJsqMessageWithCallback:(JsqMsgBlock)callback;
@end
