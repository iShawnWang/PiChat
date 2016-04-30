//
//  NewMomentViewController.m
//  PiChat
//
//  Created by pi on 16/3/18.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "NewMomentViewController.h"
#import "NewMomentPhotoViewerController.h"
#import "CommenUtil.h"
#import "GCPlaceholderTextView.h"
#import "Moment.h"
#import "MBProgressHUD+Addition.h"
#import "User.h"
#import "MomentsManager.h"

@interface NewMomentViewController ()
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *textView;
@property (weak, nonatomic) NewMomentPhotoViewerController *photoViewerController;
@property (strong,nonatomic) MomentsManager *momentsManager;
@end

@implementation NewMomentViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postMomentNotification:) name:kPostMomentNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Getter Setter

-(MomentsManager *)momentsManager{
    if(!_momentsManager){
        _momentsManager=[MomentsManager new];
    }
    return _momentsManager;
}

#pragma mark -

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.photoViewerController.currentState=PhotoViewerStateNormal;
    [self.photoViewerController.collectionView reloadData];
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    NSString *textContent= [self.textView.text trim];
    if(!textContent || textContent.length == 0){
        [MBProgressHUD showMsg:@"请输入你的现在的想法 ~" forSeconds:1.5];
        return;
    }
    [MBProgressHUD showProgressInView:self.view];
    NSArray *imgUrls= self.photoViewerController.photoUrls;
    [self.momentsManager postMomentWithContent:self.textView.text images:imgUrls];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kNewMomentPhotoViewerControllerID]){
        self.photoViewerController=segue.destinationViewController;
        self.photoViewerController.photoViewerType=PhotoViewerTypePick;
        CALayer *layer= self.photoViewerController.view.layer;
        layer.borderColor=[UIColor colorFromHexString:@"DEDEDE"].CGColor;
        layer.borderWidth=1;
    }
}

#pragma mark - Notification
-(void)postMomentNotification:(NSNotification*)noti{
    switch (noti.postState) {
        case PostMomentStateComplete: {
            [MBProgressHUD hide];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case PostMomentStateProgress: {
            [MBProgressHUD HUDForView:self.view].progress=noti.postProgress;
            break;
        }
        case PostMomentStateFailed: {
            [MBProgressHUD hide];
            [CommenUtil showMessage:[NSString stringWithFormat:@"下载失败 : %@",noti.error] inVC:self];
            break;
        }
    }
}
@end
