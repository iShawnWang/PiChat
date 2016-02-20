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

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
- (IBAction)logIn:(id)sender {
    NSString *userName=[self.userNameTextField.text trim];
    NSString *pwd=[self.pwdTextField.text trim];
    if([RegexUtil isEmail:userName]){
        [UserManager logInWithUserName:userName pwd:pwd callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [[ConversationManager sharedConversationManager]setupConversationClientWithCallback:^(BOOL succeeded, NSError *error) {
                    [StoryBoardHelper switchToMainTabVC];
                }];
            }
        }];
    }else{
        //错误提示
    }
}

- (IBAction)register:(id)sender {
    UIViewController *vc= [StoryBoardHelper inititialVC:@"RegisterViewController" fromSB:kLoginSB];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

@end
