//
//  MediaPicker.m
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MediaPicker.h"
#import "CommenUtil.h"
@import UIKit;
@import MobileCoreServices;


@interface MediaPicker ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (copy,nonatomic) UrlResultBlock urlCallback;
@property (strong,nonatomic) UIViewController *presentingVC;
@property (strong,nonatomic) UIImagePickerController *picker;
@end

@implementation MediaPicker
-(void)showImagePickerIn:(UIViewController *)vc withCallback:(UrlResultBlock)callback{
    [self showPickerIn:vc type:UIImagePickerControllerSourceTypePhotoLibrary showMovie:NO withCallback:callback];
}

-(void)showVideoPickerIn:(UIViewController *)vc withCallback:(UrlResultBlock)callback {
    [self showPickerIn:vc type:UIImagePickerControllerSourceTypePhotoLibrary showMovie:YES withCallback:callback];
}

-(void)showTakePhotoPickerIn:(UIViewController *)vc withCallback:(UrlResultBlock)callback{
    [self showPickerIn:vc type:UIImagePickerControllerSourceTypeCamera showMovie:NO withCallback:callback];
}

#pragma mark - Private
//    UIImagePickerControllerSourceTypeCamera UIImagePickerControllerSourceTypePhotoLibrary
-(void)showPickerIn:(UIViewController *)vc type:(UIImagePickerControllerSourceType)type showMovie:(BOOL)showMovie withCallback:(UrlResultBlock)callback{
    self.urlCallback=callback;
    if(![UIImagePickerController isSourceTypeAvailable:type]){
        NSError *error=[NSError errorWithDomain:@"sourceType unAvailable" code:666 userInfo:nil];
        if(self.urlCallback){
            self.urlCallback(nil,error);
        }
        return;
    }
    self.presentingVC=vc;
    self.picker=[[UIImagePickerController alloc]init];
    self.picker.sourceType=type;
    if(showMovie){
        [self.picker setMediaTypes:@[(NSString*)kUTTypeMovie]];
    }

    self.picker.delegate=self;
    [self.presentingVC presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.presentingVC dismissViewControllerAnimated:self.picker completion:nil];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType= info[UIImagePickerControllerMediaType];
        NSURL *url;
        if([mediaType isEqualToString:(NSString*)kUTTypeImage]){
            //先把图片存到 Document 目录...返回在 document 目录中的 url
            UIImage *img= info[UIImagePickerControllerOriginalImage];
            NSString *path= [CommenUtil saveDataToDocument:UIImagePNGRepresentation(img) fileName:[CommenUtil uuid]];
            url= [NSURL URLWithString:path];
        }else if([mediaType isEqualToString:(NSString*)kUTTypeMovie]){
            url=info[UIImagePickerControllerMediaURL];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.urlCallback(url,nil);
        });
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.presentingVC dismissViewControllerAnimated:self.picker completion:nil];
}
@end
