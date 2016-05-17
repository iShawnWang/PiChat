//
//  ContactCell.h
//  PiChat
//
//  Created by pi on 16/3/17.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

static NSString *const kContactCellID=@"ContactCell";

@interface ContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

-(void)configWithUser:(User*)u;
@end
