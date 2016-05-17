//
//  AddFriendCell.h
//  PiChat
//
//  Created by pi on 16/5/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface AddFriendCell : UITableViewCell
-(void)configWithUser:(User*)user;
@end
