//
//  MeViewController.m
//  PiChat
//
//  Created by pi on 16/2/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MeViewController.h"
#import "UserManager.h"
#import "User.h"
#import <UIImageView+WebCache.h>
#import "MediaPicker.h"
#import "FileUpLoader.h"
#import "MBProgressHUD+Addition.h"

@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong,nonatomic) MediaPicker *avatarPicker;
@end

@implementation MeViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"我";
        self.tabBarItem.image=[UIImage imageNamed:@"menu"];
    }
    return self;
}
-(MediaPicker *)avatarPicker{
    if(!_avatarPicker){
        _avatarPicker=[[MediaPicker alloc]init];
    }
    return _avatarPicker;
}

-(void)viewDidLoad{
    if(!self.user){
        self.user=[User currentUser];
    }
    self.userNameLabel.text=self.user.displayName;
    if(self.user.avatarPath){
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatarPath]];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadingMediaNotification:) name:kUploadMediaNotification object:nil];
}

- (IBAction)changeUserName:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text=self.user.displayName;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf= [alert.textFields firstObject];
        self.user.displayName=tf.text;
        [self.user updateUserWithCallback:^(User *user, NSError *error) {
            self.user=[User currentUser];
            self.userNameLabel.text=user.displayName;
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)changeAvatar:(id)sender {
    [self.avatarPicker showImagePickerIn:self withCallback:^(NSURL *url, NSError *error) {
        [MBProgressHUD showProgressInView:self.view];
        //上传头像为 AVFile 然后user.avatarPath 关联到 AVFile
        [[FileUpLoader sharedFileUpLoader]uploadFileAtUrl:url];
    }];
}
-(void)uploadingMediaNotification:(NSNotification*)noti{
    UploadState uploadState= [noti.userInfo[kUploadState] integerValue];
    switch (uploadState) {
        case UploadStateComplete:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AVFile *file=noti.userInfo[kUploadedFile];
            self.user.avatarPath=file.url;
            [self.user updateUserWithCallback:^(User *user, NSError *error) {
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarPath]];
                self.user=[User currentUser];
            }];
            
        }
            break;
        case UploadStateProgress:{
            NSNumber *progress= noti.userInfo[kUploadingProgress];
            [MBProgressHUD HUDForView:self.view].progress=[progress floatValue];
        }
            break;
        case UploadStateFailed:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSError *error=noti.userInfo[kUploadingError];
            NSLog(@"上传失败 : %@",error);
        }
            break;
    }
}

#pragma mark - Table Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"logOut"]) {
        [UserManager logOut];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
