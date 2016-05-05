//
//  ClearCacheCell.h
//  PiChat
//
//  Created by pi on 16/5/5.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kClearCacheCellID;
@interface ClearCacheCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *clearCacheBtn;
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
-(void)calcCacheSizeAndReloadCell;
@end
