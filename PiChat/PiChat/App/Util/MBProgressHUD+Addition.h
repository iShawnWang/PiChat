//
//  MBProgressHUD+Addition.h
//  PiChat
//
//  Created by pi on 16/3/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Addition)
+ (MBProgressHUD *)createHUD;

+(void)showMsg:(NSString*)msg forSeconds:(NSTimeInterval)second;

+(void)showForSeconds:(NSTimeInterval)second;

+(void)show;

+(void)showInView:(UIView*)v;

+(void)hide;

+(void)hideAfter:(NSTimeInterval)second;
@end
