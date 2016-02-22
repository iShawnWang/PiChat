//
//  MediaPicker.h
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
@class UIViewController;

@interface MediaPicker : NSObject
-(void)showImagePickerIn:(UIViewController *)vc withCallback:(UrlResultBlock)callback;

-(void)showVideoPickerIn:(UIViewController *)vc withCallback:(UrlResultBlock)callback;

-(void)showTakePhotoPickerIn:(UIViewController *)vc withCallback:(UrlResultBlock)callback;
@end
