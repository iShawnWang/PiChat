//
//  StoryBoardHelper.h
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kMainSB=@"Main";
static NSString *const kLoginSB=@"Login";
static NSString *const kAboutMeSB=@"AboutMe";
static NSString *const kContactSB=@"Contact";
static NSString *const kMessagesSB=@"Messages";
static NSString *const kMomentsSB=@"Moments";

@class UIViewController;
@interface StoryBoardHelper : NSObject
+(UIViewController*)mainTabViewController;
+(UIViewController*)loginViewController;
//
+(UIViewController*)initialViewControllerFromSBName:(NSString*)sbName;
+(UIViewController*)inititialVC:(NSString*)vcName fromSB:(NSString*)sbName;
//
+(void)switchToMainTabVC;
+(void)switchToLoginVC;
@end
