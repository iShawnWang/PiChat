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
@property (assign,nonatomic) NSInteger unReadCount; //显示 bedge 用
/**
 *  找到和我聊天的那个人的 objectID.仅 1v1 聊天时可以用这个方法.
 *
 *  @return
 */
-(NSString*)chatToUserId;
@end
