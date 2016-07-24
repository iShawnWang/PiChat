//
//  LocationViewerController.h
//  PiChat
//
//  Created by pi on 16/3/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocationViewerController;
@class CLLocation;

typedef enum : NSUInteger {
    LocationViewerActionView,
    LocationViewerActionPickLocation
} LocationViewerAction;

@protocol LocationViewerDelegate <NSObject>
-(void)locationViewerController:(LocationViewerController*)viewer didPickLocation:(CLLocation*)location;
@end

@class CLLocation;

/**
 *  展示或者选择一个 Location
 */
@interface LocationViewerController : UIViewController
@property (strong,nonatomic) CLLocation *location;
@property (assign,nonatomic) LocationViewerAction action;
@property(nonatomic,weak) IBOutlet id<LocationViewerDelegate> delegate;
@end
