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
-(void)updateCacheSize{
    [CommenUtil asynCalculateDirectorySizeWithPath:[CommenUtil defaultCacheDirectoryStr] completionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        NSString *cacheSizeStr= [NSByteCountFormatter stringFromByteCount:totalSize countStyle:NSByteCountFormatterCountStyleBinary];
        if([cacheSizeStr containsString:@"Zero"]){
            cacheSizeStr= @"0 KB";
        }
        executeAsyncInMainQueue(^{
            self.cacheSizeLabel.text=cacheSizeStr;
        });
    }];
}

- (IBAction)clearCache:(id)sender {
    [CommenUtil clearCacheDirectoryWithCallback:^{
        [self updateCacheSize];
    }];
}
@end
