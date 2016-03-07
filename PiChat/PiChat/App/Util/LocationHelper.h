//
//  LocationHelper.h
//  PiChat
//
//  Created by pi on 16/3/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"

@interface LocationHelper : NSObject
+(instancetype)sharedLocationHelper;
-(void)getCurrentLocation:(LocationResultBlock)callback;
@end
