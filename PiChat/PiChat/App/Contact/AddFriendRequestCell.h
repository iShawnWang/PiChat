//
//  AddFriendRequestCell.h
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AddFriendRequest;

static NSString *const kAddFriendRequestCell=@"AddFriendRequestCell";

@interface AddFriendRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *verifyMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *denyBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusMessageLabel;

-(void)configWithAddRequest:(AddFriendRequest*)request;
@end
