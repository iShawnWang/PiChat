//
//  LoginViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "LoginViewController.h"
#import "UserManager.h"
#import "CommenUtil.h"
#import "ConversationManager.h"
#import "MBProgressHUD+Addition.h"
#import <AVOSCloudSNS.h>


NSString *const kWeiBoAppKey=@"2421425804";
NSString *const kWeiBoAppSecret=@"ece99227f17c276925ed520cabf68718";


NSString *const kQQAppKey=@"1105183951";
NSString *const kQQAppSecret=@"GTASpW3nNCnf8Cuz";

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:kWeiBoAppKey andAppSecret:kWeiBoAppSecret andRedirectURI:@""];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:kQQAppKey andAppSecret:kQQAppSecret andRedirectURI:@""];
}

#pragma mark -
- (IBAction)logIn:(id)sender {
    NSString *userName=[self.userNameTextField.text trim];
    NSString *pwd=[self.pwdTextField.text trim];
    [self.view endEditing:YES];
    if([RegexUtil isEmail:userName]){
        
        [[UserManager sharedUserManager] logInWithUserName:userName pwd:pwd callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [[ConversationManager sharedConversationManager]setupConversationClientWithCallback:^(BOOL succeeded, NSError *error) {
                    [self.view endEditing:YES];
                    [StoryBoardHelper switchToMainTabVC];
                }];
            }else{
                [CommenUtil showMessage:[error description] inVC:self];
            }
        }];
    }else{
        [MBProgressHUD showMsg:@"请输入正确的 Emial 用户名" forSeconds:1.5];
    }
}

- (IBAction)register:(id)sender {
    
    NSString *userName=[self.userNameTextField.text trim];
    NSString *pwd=[self.pwdTextField.text trim];
    [self.view endEditing:YES];
    if([RegexUtil isEmail:userName]){
        [[UserManager sharedUserManager] signUpWithUserName:userName pwd:pwd callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [[ConversationManager sharedConversationManager]setupConversationClientWithCallback:^(BOOL succeeded, NSError *error) {
                    [self.view endEditing:YES];
                    [StoryBoardHelper switchToMainTabVC];
                }];
            }else{
                [CommenUtil showMessage:[error description] inVC:self];
            }
        }];
    }else{
        [MBProgressHUD showMsg:@"请输入合法的 Emial 用户名" forSeconds:1.5];
    }

}

#pragma mark - SNS
- (IBAction)weibo:(id)sender {
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        NSString *displayName = object[@"username"];
        NSString *avatarPath = object[@"avatar"];
        if([self showLogInErrorIfNeed:error]){
            return ;
        }
        [self logInOrCreateUserFromAuthData:object platform:AVOSCloudSNSPlatformWeiBo displayName:displayName avatarPath:avatarPath];
        
    } toPlatform:AVOSCloudSNSSinaWeibo];
}

- (IBAction)qq:(id)sender {
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        NSString *displayName = object[@"username"];
        NSString *avatarPath = object[@"avatar"];
        if([self showLogInErrorIfNeed:error]){
            return ;
        }
        [self logInOrCreateUserFromAuthData:object platform:AVOSCloudSNSPlatformQQ displayName:displayName avatarPath:avatarPath];
        
    } toPlatform:AVOSCloudSNSQQ];
}

- (IBAction)weChat:(id)sender {
    [MBProgressHUD showMsg:@"我暂无微信开发者认证" forSeconds:1.5];
}

-(void)logInOrCreateUserFromAuthData:(id)authData platform:(NSString*)platform displayName:(NSString*)displayName avatarPath:(NSString*)avatarPath{
    User *u= [User objectWithClassName:@"_User"];
    
    [u addAuthData:authData platform:platform block:^(AVUser *user, NSError *error) {
        if([self showLogInErrorIfNeed:error]){
            return ;
        }
        if([user isKindOfClass:[User class]]){
            
            User *u=(User*)user;
            u.avatarPath=avatarPath;
            u.displayName=displayName;
            
            [u updateUserWithCallback:^(User *user, NSError *error) {
                
                if([self showLogInErrorIfNeed:error]){
                    return ;
                }
                
                [[ConversationManager sharedConversationManager]setupConversationClientWithCallback:^(BOOL succeeded, NSError *error) {
                    [self.view endEditing:YES];
                    [StoryBoardHelper switchToMainTabVC];
                }];
            }];
        }
    }];
}

-(BOOL)showLogInErrorIfNeed:(NSError*)error{
    if(error){
        [CommenUtil showMessage:[NSString stringWithFormat:@"登录失败 : %@",error] inVC:self];
        return YES;
    }
    return NO;
}

//    NSString *accessToken = object[@"access_token"];
//    NSString *username = object[@"username"];
//    NSString *avatarPath = object[@"avatar"];
//    NSDictionary *rawUser = object[@"raw-user"]; // 性别等第三方平台返回的用户信息
@end
