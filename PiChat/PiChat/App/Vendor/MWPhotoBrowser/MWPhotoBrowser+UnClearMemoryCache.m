//
//  MWPhotoBrowser+UnClearMemoryCache.m
//  PiChat
//
//  Created by pi on 16/5/1.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MWPhotoBrowser+UnClearMemoryCache.h"
#import <MWPhotoBrowser.h>


#define SuppressUndeclaredSelectorWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation MWPhotoBrowser (UnClearMemoryCache)
-(void)dealloc{
    SuppressUndeclaredSelectorWarning(
      [self performSelector:@selector(clearCurrentVideo) withObject:nil];
      [self setValue:nil forKey:@"_pagingScrollView"];
      [[NSNotificationCenter defaultCenter] removeObserver:self];
      [self performSelector:@selector(releaseAllUnderlyingPhotos:) withObject:@(NO)];
    );
    //    [[SDImageCache sharedImageCache] clearMemory]; // clear memory 我们这里不需要清除
    //还提了个 issues 问作者问什么清除 ~ https://github.com/mwaterfall/MWPhotoBrowser/issues/496
    
}
@end
