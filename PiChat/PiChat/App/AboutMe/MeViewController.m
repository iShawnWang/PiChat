//
//  MeViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MeViewController.h"
#import "UserManager.h"

@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@end

@implementation MeViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"我";
        self.tabBarItem.image=[UIImage imageNamed:@"menu"];
    }
    return self;
}
- (IBAction)logOut:(id)sender {
    [UserManager logOut];
}

@end
