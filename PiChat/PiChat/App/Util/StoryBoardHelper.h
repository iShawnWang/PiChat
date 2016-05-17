//
//  StoryBoardHelper.h
//  PiChat
//
//  Created by pi on 16/2/19.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kMainSB;
FOUNDATION_EXPORT NSString *const kLoginSB;
FOUNDATION_EXPORT NSString *const kAboutMeSB;
FOUNDATION_EXPORT NSString *const kContactSB;
FOUNDATION_EXPORT NSString *const kMessagesSB;
FOUNDATION_EXPORT NSString *const kMomentsSB;

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
