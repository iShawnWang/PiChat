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
#import "ImageCache.h"
#import "NSNotification+DownloadImage.h"
#import "LeanCloudManager.h"

NSString *const kResuseIdLogOut=@"logOut";
NSString *const kResuseIdFeedback=@"feedback";

@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong,nonatomic) MediaPicker *avatarPicker;
@property (strong,nonatomic) ImageCache *imageCache;
@end

@implementation MeViewController

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarItem.title=@"我";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_me"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_meHL"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadingMediaNotification:) name:kUploadMediaNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadImageNotification:) name:kDownloadImageCompleteNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.user){
        self.user=[User currentUser];
    }
    self.userNameLabel.text=self.user.displayName;
    if(self.user.avatarPath){
        [self.avatarImageView setImage:[self.imageCache findOrFetchImageFormUrl:self.user.avatarPath]];
    }
}

#pragma mark - Getter Setter
-(MediaPicker *)avatarPicker{
    if(!_avatarPicker){
        _avatarPicker=[[MediaPicker alloc]init];
    }
    return _avatarPicker;
}
-(ImageCache *)imageCache{
    if(!_imageCache){
        _imageCache=[ImageCache sharedImageCache];
    }
    return _imageCache;
}

#pragma mark -

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

#pragma mark - 上传头像图片 通知
-(void)uploadingMediaNotification:(NSNotification*)noti{
    UploadState uploadState = noti.uploadState;
    switch (uploadState) {
        case UploadStateComplete:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AVFile *file=noti.uploadedFile;
            self.user.avatarPath=file.url;
            [self.user updateUserWithCallback:^(User *user, NSError *error) {
                self.avatarImageView.image= [self.imageCache findOrFetchImageFormUrl:user.avatarPath];
                self.user=[User currentUser];
            }];
            
        }
            break;
        case UploadStateProgress:{
            [MBProgressHUD HUDForView:self.view].progress=noti.progress;
        }
            break;
        case UploadStateFailed:{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"上传失败 : %@",noti.error);
        }
            break;
    }
}

#pragma mark - 下载头像 通知,更新此界面头像
-(void)downloadImageNotification:(NSNotification*)noti{
    UIImage *img= noti.image;
    NSURL *url= noti.imageUrl;
    if([url.absoluteString isEqualToString:self.user.avatarPath]){
        self.avatarImageView.image=img;
    }
}

#pragma mark - Table Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:kResuseIdLogOut]) {
        [UserManager logOut];
    }else if([cell.reuseIdentifier isEqualToString:kResuseIdFeedback]){
        [LeanCloudManager showFeedBackIn:self];
    }
}

@end
