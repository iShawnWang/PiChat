//
//  ModelSizeCache.h
//  PiChat
//
//  Created by pi on 16/4/28.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "PiAutoPurgeCache.h"
@import UIKit;

@protocol UniqueObject <NSObject>

-(id)uniqueID;

@end



typedef CGSize (^CalcModelSizeBlock)(id <UniqueObject> model,UIView *collectionOrTableView);

/**
 *  缓存行高的工具类,Model 需实现 UniqueObject protocal ,返回代表这个 model 的唯一 ID
 *  计算一次行高后存入 NSCache 中,model 的 uniqueID 作为 key,cell Size 作为 value.
 */
@interface ModelSizeCache : NSObject

-(CGSize)getSizeForModel:(id <UniqueObject>)model withView:(UIView*)view orCalc:(CalcModelSizeBlock)block;

-(void)invalidateCacheForModels:(NSArray<UniqueObject>*)models;

-(void)clearCache;
@end
