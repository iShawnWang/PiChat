//
//  NSNotification+ReceiveMessage.h
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kDidReceiveTypedMessageNotification =@"didReceiveTypedMessageNotification";

@class AVIMTypedMessage;
@interface NSNotification (ReceiveMessage)
@property (strong,nonatomic,readonly) AVIMTypedMessage *message;
+(void)postReceiveMessageNotification:(id)object message:(AVIMTypedMessage*)message;
@end
