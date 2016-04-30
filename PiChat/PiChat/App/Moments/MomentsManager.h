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
-(void)postMomentWithContent:(NSString*)content images:(NSArray*)images;
+(void)getMomentWithID:(NSString*)momentID callback:(MomentResultBlock)callback;
+(void)getCurrentUserMoments:(ArrayResultBlock)callback;
@end
