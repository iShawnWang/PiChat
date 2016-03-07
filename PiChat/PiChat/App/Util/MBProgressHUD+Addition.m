//
//  MBProgressHUD+Addition.m
//  PiChat
//
//  Created by pi on 16/3/4.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MBProgressHUD+Addition.h"

@implementation MBProgressHUD (Addition)
+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    return HUD;
}

+(void)showMsg:(NSString*)msg forSeconds:(NSTimeInterval)second{
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud=[[MBProgressHUD alloc]initWithWindow:window];
    [window addSubview:hud];
    
    hud.labelText=msg;
    hud.mode=MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide=YES;
    hud.bounds=CGRectMake(0,0, 66, 44);
    [hud show:YES];
    [hud hide:YES afterDelay:second];
}


static MBProgressHUD *hud;

+(void)showForSeconds:(NSTimeInterval)second{
    [self show];
    [self hideAfter:second];
}

+(void)show{
    UIView *v=[[UIApplication sharedApplication].windows lastObject];
    [self showInView:v];
}

+(void)showInView:(UIView*)v{
    hud= [[MBProgressHUD alloc]initWithView:v];
    hud.labelText=@"正在努力加载中 ~ ";
    hud.mode=MBProgressHUDModeCustomView;
    [v addSubview:hud];
    hud.removeFromSuperViewOnHide=YES;
    hud.dimBackground=YES;
    //
    [hud show:YES];
}

+(void)showProgressInView:(UIView *)v{
    hud=[[MBProgressHUD alloc]initWithView:v];
    hud.mode=MBProgressHUDModeDeterminateHorizontalBar;
    [v addSubview:hud];
    hud.removeFromSuperViewOnHide=YES;
    hud.dimBackground=YES;
    [hud show:YES];
}

+(void)hide{
    [self hideAfter:0];
}

+(void)hideAfter:(NSTimeInterval)second{
    [hud hide:YES afterDelay:second];
}
@end
