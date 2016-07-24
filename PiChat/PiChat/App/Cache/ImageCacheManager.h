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


- (BOOL)imageExistsForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName ;

-(BOOL)retrieveImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageCacheCompletionBlock)completionBlock;

-(BOOL)syncRetrieveImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageCacheCompletionBlock)completionBlock;

/**
 *
 *
 *  @param entity
 *  @param formatName
 *  @param sync            同步获取
 *  @param completionBlock
 *
 *  @return 缓存中有图片
 */
- (BOOL)retrieveImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName sync:(BOOL)sync completionBlock:(FICImageCacheCompletionBlock)completionBlock;
@end
