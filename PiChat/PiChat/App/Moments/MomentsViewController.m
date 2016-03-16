//
//  MomentsViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentsViewController.h"

@interface MomentsViewController ()

@end

@implementation MomentsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"朋友圈";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_discover"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_discoverHL"];
    }
    return self;
}

@end
