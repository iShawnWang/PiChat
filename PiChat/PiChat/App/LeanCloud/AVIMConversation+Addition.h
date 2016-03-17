//
//  AVIMConversation+Addition.h
//  PiChat
//
//  Created by pi on 16/3/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVIMConversation.h"
@class AVIMTypedMessage;
@interface AVIMConversation (Addition)
@property (copy,nonatomic) AVIMTypedMessage *lastMessage;

-(NSString*)chatToUserId;
@end
