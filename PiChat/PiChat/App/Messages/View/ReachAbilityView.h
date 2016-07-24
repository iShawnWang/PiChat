//
//  ReachAbilityView.h
//  PiChat
//
//  Created by pi on 16/6/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReachAbilityView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
+(instancetype)loadViewFroNib;
-(void)showUnReachableInTableView:(UITableView*)tableView;
-(void)hideForTableView:(UITableView*)tableView;
@end
