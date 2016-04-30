//
//  NSNotification+LocationCellUpdate.h
//  PiChat
//
//  Created by pi on 16/3/14.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JSQMessage;
//给 JSQLocationCell 设置位置是异步的,它会先创建 MapView 然后截取 snapShot ,需要 用Notification刷新 Cell
static NSString *const kLocationCellNeedUpdateNotification=@"kLocationCellNeedUpdateNotification";

@interface NSNotification (LocationCellUpdate)
@property (strong,nonatomic,readonly) JSQMessage *jsqMessageThatNeedUpdate;
+(void)postLocationCellNeedUpdateNotification:(id)object;
@end
