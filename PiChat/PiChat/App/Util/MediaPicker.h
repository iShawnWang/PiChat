//
//  MediaPicker.h
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import <QBImagePickerController.h>

@interface MediaPicker : QBImagePickerController
-(void)showImagePickerIn:(UIViewController*)vc multipleSelectionCount:(NSInteger)count callback:(ArrayResultBlock)callback;

-(void)showImagePickerIn:(UIViewController *)vc multipleSelectionCount:(NSInteger)count imgUrlsCallback:(ArrayResultBlock)callback;

-(void)showVideoPickerIn:(UIViewController*)vc callback:(UrlResultBlock)callback;
@end
