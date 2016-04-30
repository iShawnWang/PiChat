//
//  ModelSizeCache.h
//  PiChat
//
//  Created by pi on 16/4/28.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "PiAutoPurgeCache.h"
@import UIKit;

typedef CGSize (^CalcModelSizeBlock)(NSObject *model,UIView *collectionOrTableView);

@interface ModelSizeCache : NSObject

-(CGSize)getSizeForModel:(NSObject*)model withView:(UIView*)view orCalc:(CalcModelSizeBlock)block;

-(void)invalidateCacheForModels:(NSArray*)models;

-(void)clearCache;
@end
