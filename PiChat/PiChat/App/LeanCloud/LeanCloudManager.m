//
//  LeanCloudManager.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "LeanCloudManager.h"
#import <AVOSCloud.h>
#import <AVOSCloudIM.h>
#import <LeanCloudFeedback.h>
#import <IQKeyboardManager.h>

#define kMyApplicationId @"RD1BgVPwanbUP6t0dGdniPvI-gzGzoHsz"
#define kMyClientKey @"qeQ9Tmht9fmLG3D6YEL4WJRq"

@implementation LeanCloudManager
+(void)setupApplication:(NSDictionary*)launchOptions{
#if DEBUG
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVOSCloud setAllLogsEnabled:YES];
#endif
    [AVOSCloud setApplicationId:kMyApplicationId clientKey:kMyClientKey];
}

+(void)showFeedBackIn:(UIViewController*)vc{
    LCUserFeedbackViewController *feedBackVC=[LCUserFeedbackViewController new];
    
    feedBackVC.contactHeaderHidden=YES;
    feedBackVC.navigationBarStyle=LCUserFeedbackNavigationBarStyleNone;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:feedBackVC];
    [vc presentViewController:nav animated:YES completion:^{
        //auto popup keyboard
        UITextField *inputTextField= [feedBackVC valueForKey:@"inputTextField"];
        [inputTextField becomeFirstResponder];
    }];
}
@end
