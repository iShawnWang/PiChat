//
//  MediaViewerController.m
//  PiChat
//
//  Created by pi on 16/2/15.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MediaViewerController.h"
#import "LocationViewerController.h"
#import "MWPhotoBrowser+UnClearMemoryCache.h"

@implementation MediaViewerController


+(void)showIn:(UIViewController*)controller withImage:(UIImage*)img {
    MWPhoto *photo=[MWPhoto photoWithImage:img];
    [self showIn:controller withPhotos:@[photo]];
}

+(void)showIn:(UIViewController *)controller withImageUrl:(NSURL*)imgUrl{
    MWPhoto *photo=[MWPhoto photoWithURL:imgUrl];
    [self showIn:controller withPhotos:@[photo]];
}

+(void)showIn:(UIViewController*)controller withVideoUrl:(NSURL*)url{
    MWPhoto *video=[[MWPhoto alloc]initWithVideoURL:url];
    video.isVideo=YES;
    [self showIn:controller withPhotos:@[video]];
}

+(void)showIn:(UIViewController*)controller withPhotos:(NSArray*)photos{
    MWPhotoBrowser *photoBrowser=[[MWPhotoBrowser alloc]initWithPhotos:photos];
    
    photoBrowser.view.backgroundColor=[UIColor whiteColor];
    if(controller.navigationController){
        [controller.navigationController pushViewController:photoBrowser animated:YES ];
    }
}

+(void)showIn:(UIViewController *)controller withLocation:(CLLocation *)location{
    LocationViewerController *locationVC=[[LocationViewerController alloc]init];
    locationVC.location=location;
    locationVC.action=LocationViewerActionView;
    if(controller.navigationController){
        [controller.navigationController pushViewController:locationVC animated:YES];
    }
}
@end
