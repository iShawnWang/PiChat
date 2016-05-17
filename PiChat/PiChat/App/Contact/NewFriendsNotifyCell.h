//
//  NewFriendsNotifyCell.h
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kNewFriendsNotifyCell=@"NewFriendsNotifyCell";

@interface NewFriendsNotifyCell : UITableViewCell
-(void)configWithBedgeCount:(NSInteger)count;
@end
