//
//  User+FICEntity.h
//  PiChat
//
//  Created by pi on 16/7/10.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "User.h"
#import "FICEntity.h"

FOUNDATION_EXPORT NSString *const kUserAvatarFamily;
FOUNDATION_EXPORT NSString *const kUserAvatarOriginalFormatName;
FOUNDATION_EXPORT NSString *const kUserAvatarBlurFormatName;
FOUNDATION_EXPORT NSString *const kUserAvatarRoundFormatName;

FOUNDATION_EXPORT const CGSize kUserAvatarOriginalImageSize;
FOUNDATION_EXPORT const CGSize kUserAvatarBlurImageSize;
FOUNDATION_EXPORT const CGSize kUserAvatarRoundImageSize;

@interface User (FICEntity)<FICEntity>

@end
