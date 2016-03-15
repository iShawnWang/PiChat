//
//  RegisterViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserManager.h"
#import "CommenUtil.h"
#import "ConversationManager.h"
#import "MBProgressHUD+Addition.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)register:(id)sender {
    NSString *userName=[self.userNameTextField.text trim];
    NSString *pwd=[self.pwdTextField.text trim];
    if([RegexUtil isEmail:userName]){
        [[UserManager sharedUserManager] signUpWithUserName:userName pwd:pwd callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [[ConversationManager sharedConversationManager]setupConversationClientWithCallback:^(BOOL succeeded, NSError *error) {
                    [self.view endEditing:YES];
                    [StoryBoardHelper switchToMainTabVC];
                }];
            }else{
                [CommenUtil showMessage:[error description] in:self];
            }
        }];
    }else{
        [MBProgressHUD showMsg:@"请输入合法的 Emial 用户名" forSeconds:1.5];
    }
}

@end
