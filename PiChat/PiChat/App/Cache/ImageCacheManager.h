//
//  ImageCacheManager.h
//  PiChat
//
//  Created by pi on 16/7/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FastImageCache.h"
#import "JSQMessage+FICEntity.h"
#import "AVFile+FICEntity.h"
#import "User+FICEntity.h"


@interface ImageCacheManager : NSObject
+(instancetype)sharedImageCacheManager;
-(void)setupImageCache;

- (BOOL)retrieveImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageCacheCompletionBlock)completionBlock ;
@end
