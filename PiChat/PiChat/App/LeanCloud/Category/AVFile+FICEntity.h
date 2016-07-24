//
//  AVFile+FICEntity.h
//  PiChat
//
//  Created by pi on 16/7/8.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AVFile.h"
#import "FICEntity.h"
#import "GlobalConstant.h"

FOUNDATION_EXPORT NSString *const kMomentFamily;
FOUNDATION_EXPORT NSString *const kMomentThumbnailFormatName;

FOUNDATION_EXPORT const CGSize kMomentThumbnailImageSize;

@interface AVFile (FICEntity)<FICEntity>

@end
