//
//  MediaViewerController.m
//  PiChat
//
//  Created by pi on 16/2/15.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MediaViewerController.h"
#import <MWPhotoBrowser.h>
#import "LocationViewerController.h"

@implementation MediaViewerController

+(void)showIn:(UIViewController*)controller withImage:(UIImage*)img{
    MWPhoto *photo=[MWPhoto photoWithImage:img];
    MWPhotoBrowser *photoBrowser=[[MWPhotoBrowser alloc]initWithPhotos:@[photo]];
    if(controller.navigationController){
        [controller.navigationController pushViewController:photoBrowser animated:YES];
    }
}

+(void)showIn:(UIViewController*)controller withVideoUrl:(NSURL*)url{
    MWPhoto *video=[[MWPhoto alloc]initWithVideoURL:url];
    MWPhotoBrowser *photoBrowser=[[MWPhotoBrowser alloc]initWithPhotos:@[video]];
    photoBrowser.autoPlayOnAppear=YES;
    if(controller.navigationController){
        [controller.navigationController pushViewController:photoBrowser animated:YES];
    }
}

+(void)showIn:(UIViewController *)controller withLocation:(CLLocation *)location{
    LocationViewerController *locationVC=[[LocationViewerController alloc]init];
    locationVC.location=location;
    if(controller.navigationController){
        [controller.navigationController pushViewController:locationVC animated:YES];
    }
}
@end
