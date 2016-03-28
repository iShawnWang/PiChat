//
//  MainTabBarController.m
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MainTabBarController.h"
#import "StoryBoardHelper.h"
#import "UIColor+Addition.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubControllers];
}

#pragma mark - Private
-(void)setupSubControllers{
    self.viewControllers=@[[StoryBoardHelper initialViewControllerFromSBName:kMessagesSB],
                           [StoryBoardHelper initialViewControllerFromSBName:kContactSB],
                           [StoryBoardHelper initialViewControllerFromSBName:kMomentsSB],
                           [StoryBoardHelper initialViewControllerFromSBName:kAboutMeSB]];
    [UITabBar appearance].tintColor=[UIColor colorFromHexString:@"06BEBD"];
}

@end
