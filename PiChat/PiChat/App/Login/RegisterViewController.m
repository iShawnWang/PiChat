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
        [UserManager signUpWithUserName:userName pwd:pwd callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [StoryBoardHelper switchToMainTabVC];
            }
        }];
    }else{
        //错误提示
    }
}

@end
