//
//  JSQMessage+MessageID.h
//  PiChat
//
//  Created by pi on 16/3/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <JSQMessages.h>

@interface JSQMessage (MessageID)
@property (copy,nonatomic) NSString *messageID; //AVIMTypedMessage 的 messageID
@property (assign,nonatomic) int64_t timeStamp; //AVIMTypedMessage 的 timeStamp
@end
