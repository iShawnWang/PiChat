//
//  LoginViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITabBarController *mainTab=[[UITabBarController alloc]init];
    UIStoryboard *aboutMeSB=[UIStoryboard storyboardWithName:@"AboutMe" bundle:nil];
    UIStoryboard *contactSB=[UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    UIStoryboard *messagesSB=[UIStoryboard storyboardWithName:@"Messages" bundle:nil];
    UIStoryboard *momentsSB=[UIStoryboard storyboardWithName:@"Moments" bundle:nil];
    mainTab.viewControllers=@[messagesSB.instantiateInitialViewController,
                              contactSB.instantiateInitialViewController,
                              momentsSB.instantiateInitialViewController,
                              aboutMeSB.instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController=mainTab;
}

@end
