//
//  MomentsManager.h
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import "NSNotification+PostMoment.h"

@interface MomentsManager : NSObject
/**
 *  发送一条朋友圈
 *
 *  @param content
 *  @param images
 */
-(void)postMomentWithContent:(NSString*)content images:(NSArray*)images;

/**
 *  获取某条朋友圈
 *
 *  @param momentID
 *  @param callback
 */
+(void)getMomentWithID:(NSString*)momentID callback:(MomentResultBlock)callback;

/**
 *  获取我的朋友发送的朋友圈
 *
 *  @param callback
 */
+(void)getCurrentUserMoments:(ArrayResultBlock)callback;
@end
