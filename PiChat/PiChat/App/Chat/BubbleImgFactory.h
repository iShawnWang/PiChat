//
//  BubbleImgFactory.h
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h>

/**
 *  生成聊天气泡的 factory
 */
@interface BubbleImgFactory : JSQMessagesBubbleImageFactory
+(instancetype)sharedBubbleImgFactory;
-(JSQMessagesBubbleImage *)bubbleImgForMessage:(JSQMessage*)msg;
@end
