//
//  ClearCacheCell.m
//  PiChat
//
//  Created by pi on 16/5/5.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "ClearCacheCell.h"
#import "CommenUtil.h"
#import <AVOSCloud.h>
#import <SDImageCache.h>
#import "MBProgressHUD+Addition.h"

NSString *const kClearCacheCellID=@"ClearCacheCell";
@implementation ClearCacheCell

-(void)awakeFromNib{
    self.cacheSizeLabel.text=@"";
}
-(void)calcCacheSize{
    executeAsyncInGlobalQueue(^{
        unsigned long long size;
        NSError *error;
        [CommenUtil getAllocatedSize:&size ofDirectoryAtURL:[NSURL URLWithString:[CommenUtil defaultCacheDirectoryStr]] error:&error];
        NSString *cacheSizeStr= [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
        executeAsyncInMainQueue(^{
            self.cacheSizeLabel.text=cacheSizeStr;
        });
    });
    
//    NSArray *contents= [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[CommenUtil defaultCacheDirectoryStr] error:nil];
//    NSLog(@"%@",contents);
//    
//    NSLog(@"%@",[CommenUtil cacheDirectoryStr]);
    
}

- (IBAction)clearCache:(id)sender {
    //清除 SDW leancloud ,我自己的 Cache 目录下的缓存文件.没有清除 Cache 目录下所有文件
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [CommenUtil clearCacheDirectoryWithCallback:^{
            [AVFile clearAllCachedFiles];
            [MBProgressHUD showMsg:@"清除成功" forSeconds:1.0];
            [self calcCacheSizeAndReloadCell];
        }];
    }];
}
@end
