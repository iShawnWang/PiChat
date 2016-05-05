//
//  NSNotification+ReceiveMessage.m
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NSNotification+ReceiveMessage.h"
#import "NSNotification+Post.h"

NSString *const kDidReceiveTypedMessageNotification =@"didReceiveTypedMessageNotification";
static NSString *const kTypedMessage =@"kTypedMessage";
@implementation NSNotification (ReceiveMessage)


+(void)postReceiveMessageNotification:(id)object message:(AVIMTypedMessage*)message{
    [[NSNotification notificationWithName:kDidReceiveTypedMessageNotification object:object userInfo:@{kTypedMessage :message}]post];
}

-(AVIMTypedMessage *)message{
    return self.userInfo[kTypedMessage] ;
}
@end
