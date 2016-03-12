//
//  MeViewController.h
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface MeViewController : UITableViewController
@property (strong,nonatomic) User *user;
@end
