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
#import "Moment.h"
#import "Comment.h"

//leancloud 官方提供的 测试账号
#define kApplicationId @"g7gz9oazvrubrauf5xjmzp3dl12edorywm0hy8fvlt6mjb1y"
#define kClientKey @"01p70e67aet6dvkcaag9ajn5mff39s1d5jmpyakzhd851fhx"

//我申请滴..
#define kMyApplicationId @"RD1BgVPwanbUP6t0dGdniPvI-gzGzoHsz"
#define kMyClientKey @"qeQ9Tmht9fmLG3D6YEL4WJRq"

@implementation LeanCloudManager
+(void)setupApplication:(NSDictionary*)launchOptions{
    [Moment registerSubclass];
    [Comment registerSubclass];
#if DEBUG
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVOSCloud setAllLogsEnabled:YES];
#endif
    [AVOSCloud setApplicationId:kMyApplicationId clientKey:kMyClientKey];
}

+(void)showFeedBackIn:(UIViewController*)vc{
    LCUserFeedbackViewController *feedBackVC=[LCUserFeedbackViewController new];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[LCUserFeedbackViewController class]];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[LCUserFeedbackViewController class]];
    feedBackVC.contactHeaderHidden=YES;
    feedBackVC.navigationBarStyle=LCUserFeedbackNavigationBarStyleNone;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:feedBackVC];
    [vc presentViewController:nav animated:YES completion:^{
        //自动弹出键盘
        UITextField *inputTextField= [feedBackVC valueForKey:@"inputTextField"];
        [inputTextField becomeFirstResponder];
    }];
}
@end
