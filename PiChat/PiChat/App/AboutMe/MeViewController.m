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
#import "MediaPicker.h"
#import "FileUpLoader.h"
#import "MBProgressHUD+Addition.h"
#import "ImageCache.h"
#import "NSNotification+DownloadImage.h"
#import "LeanCloudManager.h"
#import "CommenUtil.h"

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
        self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:self.user.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
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
    [self.avatarPicker showImagePickerIn:self multipleSelectionCount:1 callback:^(NSArray *objects, NSError *error) {
        [MBProgressHUD showProgressInView:self.view];
        //上传头像为 AVFile 然后user.avatarPath 关联到 AVFile
        [[FileUpLoader sharedFileUpLoader]uploadImage:objects.firstObject];
        AVFile *avatarFile= [AVFile fileWithData:UIImagePNGRepresentation(objects.firstObject)];
        
        //上传头像图片
        [avatarFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                //更新User.avatarPath
                self.user.avatarPath=avatarFile.url;
                self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:self.user.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
                [self.user updateUserWithCallback:^(User *user, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }else{
                [CommenUtil showMessage:@"上传头像失败:%@" inVC:self];
            }
        } progressBlock:^(NSInteger percentDone) {
            [MBProgressHUD HUDForView:self.view].progress=percentDone/100.0;
        }];
    }];
}

#pragma mark - 下载完图片
-(void)downloadImageNotification:(NSNotification*)noti{
    if([noti.imageUrl.absoluteString isEqualToString:self.user.avatarPath]){
        self.avatarImageView.image=[[ImageCache sharedImageCache]findOrFetchImageFormUrl:self.user.avatarPath withImageClipConfig:[ImageClipConfiguration configurationWithCircleImage:YES]];
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
