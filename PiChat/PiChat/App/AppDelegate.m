//
//  AppDelegate.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "AppDelegate.h"
#import "LeanCloudManager.h"
#import "StoryBoardHelper.h"
#import "UserManager.h"
#import "ConversationManager.h"
#import <AVOSCloudSNS.h>
#import "UIColor+Addition.h"
#import <IQKeyboardManager.h>
#import "PrivateChatController.h"

@interface AppDelegate ()

@end 

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    [LeanCloudManager setupApplication:launchOptions];
    [self setupRootController];
    return YES;
}

#pragma mark - LeanCloud SNS

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [AVOSCloudSNS handleOpenURL:url];
}

// When Build with IOS 9 SDK
// For application on system below ios 9
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [AVOSCloudSNS handleOpenURL:url];
}

// For application on system equals or larger ios 9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [AVOSCloudSNS handleOpenURL:url];
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Private
-(void)setupRootController{
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *rootVC;
    if([UserManager sharedUserManager].currentUser){
        rootVC=[StoryBoardHelper mainTabViewController];
        [[ConversationManager sharedConversationManager]setupConversationClientWithCallback:^(BOOL succeeded, NSError *error) {
            
        }];
    }else{
        rootVC=[StoryBoardHelper loginViewController];
    }
    self.window.rootViewController=rootVC;
    [self.window makeKeyAndVisible];
}

@end
