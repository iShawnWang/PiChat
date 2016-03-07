//
//  LocationViewerController.h
//  PiChat
//
//  Created by pi on 16/3/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;
@interface LocationViewerController : UIViewController
@property (strong,nonatomic) CLLocation *location;
@end
