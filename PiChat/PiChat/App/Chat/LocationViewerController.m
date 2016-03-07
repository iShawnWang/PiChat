//
//  LocationViewer.m
//  PiChat
//
//  Created by pi on 16/3/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "LocationViewerController.h"
@import CoreLocation;
@import MapKit;

@interface LocationViewerController ()
@property (strong,nonatomic) MKMapView *mapView;
@end

@implementation LocationViewerController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.mapView];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=self.location.coordinate;
    [self.mapView addAnnotation:annotation];
    //
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 150, 150);
    [self.mapView setRegion:region animated:YES];
}
@end
