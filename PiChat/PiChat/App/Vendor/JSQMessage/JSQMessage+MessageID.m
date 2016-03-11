//
//  JSQMessage+MessageID.m
//  PiChat
//
//  Created by pi on 16/3/12.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "JSQMessage+MessageID.h"
#import <objc/runtime.h>

static char const * const kMessageID = "kMessageID";
static char const * const kTimeStamp = "kTimeStamp";

@implementation JSQMessage (MessageID)
-(void)setMessageID:(NSString *)messageID{
    objc_setAssociatedObject(self, kMessageID, messageID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)messageID{
    return objc_getAssociatedObject(self, kMessageID);
}

-(void)setTimeStamp:(int64_t)timeStamp{
    objc_setAssociatedObject(self, kTimeStamp, @(timeStamp), OBJC_ASSOCIATION_ASSIGN);
}
-(int64_t)timeStamp{
    return [objc_getAssociatedObject(self, kTimeStamp) longLongValue];
}
@end
