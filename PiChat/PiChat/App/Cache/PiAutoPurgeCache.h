//
//  AutoPurgeCache.h
//  PiChat
//
//  Created by pi on 16/3/13.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  NSCache 子类,内存警告时自动释放,
 *  其他的开源项目都是用 NSDictionary 作为内存缓存,然后自己处理线程安全,同步,释放缓存等逻辑的..说比 NSCache 效率高.
 */
@interface PiAutoPurgeCache : NSCache

@end
