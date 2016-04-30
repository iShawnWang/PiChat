//
//  IQKeyboardManager+Configuration.m
//  PiChat
//
//  Created by pi on 16/4/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "IQKeyboardManager+Configuration.h"
#import "MomentsViewController.h"

@implementation IQKeyboardManager (Configuration)
+(void)setupIQKeyboardManager{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[MomentsViewController class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[MomentsViewController class]];
}
@end
