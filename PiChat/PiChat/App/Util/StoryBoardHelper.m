//
//  StoryBoardHelper.m
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "StoryBoardHelper.h"
@import UIKit;

@implementation StoryBoardHelper
+(void)switchToMainTabVC{
    [UIApplication sharedApplication].keyWindow.rootViewController=[StoryBoardHelper mainTabViewController];
}
+(void)switchToLoginVC{
    [UIApplication sharedApplication].keyWindow.rootViewController=[StoryBoardHelper loginViewController];
}
#pragma mark - 
+(UIViewController *)mainTabViewController{
    return [self initialViewControllerFromSBName:kMainSB];
}

+(UIViewController *)loginViewController{
    return [self initialViewControllerFromSBName:kLoginSB];
}

#pragma mark - Private
+(UIViewController*)initialViewControllerFromSBName:(NSString*)sbName{
    return [UIStoryboard storyboardWithName:sbName bundle:nil].instantiateInitialViewController;
}

+(UIViewController*)inititialVC:(NSString*)vcName fromSB:(NSString*)sbName{
    return [[UIStoryboard storyboardWithName:sbName bundle:nil] instantiateViewControllerWithIdentifier:vcName];
}
@end
