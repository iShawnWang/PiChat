//
//  NSNotification+LocationCellUpdate.m
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NSNotification+LocationCellUpdate.h"
#import "NSNotification+Post.h"

static NSString *const JSQMsgThatNeedUpdate=@"kJSQMsgThatNeedUpdate";
@implementation NSNotification (LocationCellUpdate)
+(void)postLocationCellNeedUpdateNotification:(id)object{
    [[NSNotification notificationWithName:kLocationCellNeedUpdateNotification object:object userInfo:@{JSQMsgThatNeedUpdate:object}]post];
}

-(JSQMessage*)jsqMessageThatNeedUpdate{
    return self.userInfo[JSQMsgThatNeedUpdate];
}
@end
