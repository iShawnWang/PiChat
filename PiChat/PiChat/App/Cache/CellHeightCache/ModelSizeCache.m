//
//  ModelSizeCache.m
//  PiChat
//
//  Created by pi on 16/4/28.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ModelSizeCache.h"

@interface ModelSizeCache ()
@property (assign,nonatomic) CGSize defaultNilCacheSize;
@property (strong,nonatomic) PiAutoPurgeCache *cacheLandscape;
@property (strong,nonatomic) PiAutoPurgeCache *cachePortrait;
@end

@implementation ModelSizeCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultNilCacheSize=CGSizeMake(-1, -1); //size 默认被初始化为 0,0 这里我们设置默认为 -1,-1
    }
    return self;
}

-(PiAutoPurgeCache *)cachePortrait{
    if(!_cachePortrait){
        _cachePortrait=[PiAutoPurgeCache new];
    }
    return _cachePortrait;
}

-(PiAutoPurgeCache *)cacheLandscape{
    if(!_cacheLandscape){
        _cacheLandscape=[PiAutoPurgeCache new];
    }
    return _cacheLandscape;
}

-(void)setOrientationSize:(CGSize)size forModel:(id <UniqueObject>)model{
    if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        [self.cachePortrait setObject:[NSValue valueWithCGSize:size] forKey:[model uniqueID]];
    }else{
        [self.cacheLandscape setObject:[NSValue valueWithCGSize:size] forKey:[model uniqueID]];
    }
}

-(NSValue*)sizeByOrientationForKey:(id)key{
    if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        return [self.cachePortrait objectForKey:key];
    }else{
        return [self.cacheLandscape objectForKey:key];
    }
}

-(CGSize)getSizeForModel:(id <UniqueObject>)model withView:(UIView*)view orCalc:(CalcModelSizeBlock)block{
    CGSize cacheSize=self.defaultNilCacheSize; //默认值 -1,-1
    //从缓存中读取 size
    NSValue *cacheSizeValue=[self sizeByOrientationForKey:[model uniqueID]];
    
    if(cacheSizeValue){
        cacheSize= cacheSizeValue.CGSizeValue;
    }
    if(cacheSize.height>-1){
//        NSLog(@"从缓存中读取 size");
        return cacheSize;
    }else{
    //没有就计算一下,在存入缓存中
        cacheSize=block(model,view);
        [self setOrientationSize:cacheSize forModel:model];
//        NSLog(@"计算size");
        return cacheSize;
    }
}

-(void)invalidateCacheForModels:(NSArray<UniqueObject>*)models{
    [models enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cachePortrait removeObjectForKey:[model uniqueID]];
        [self.cacheLandscape removeObjectForKey:[model uniqueID]];
    }];
}

-(void)clearCache{
    [self.cachePortrait removeAllObjects];
    [self.cacheLandscape removeAllObjects];
}
@end
