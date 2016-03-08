//
//  LocationViewer.m
//  PiChat
//
//  Created by pi on 16/3/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "LocationViewerController.h"
#import "BasicPinAnnotation.h"
@import CoreLocation;
@import MapKit;
#import <AddressBookUI/ABAddressFormatting.h>

@interface LocationViewerController ()<MKMapViewDelegate>
@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) CLGeocoder *geocoder;
@end

@implementation LocationViewerController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.mapView];
        self.mapView.delegate=self;
    }
    return self;
}

-(CLGeocoder *)geocoder{
    if(!_geocoder){
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BasicPinAnnotation *annotation=[[BasicPinAnnotation alloc]init];
    annotation.coordinate=self.location.coordinate;
    annotation.title=@"我的位置";
    [self.mapView addAnnotation:annotation];
    //
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 150, 150);
    [self.mapView setRegion:region animated:YES];
    
    [self.geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        BasicPinAnnotation *pin= [self.mapView.annotations firstObject];
        
        CLPlacemark *mark= [placemarks lastObject];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        pin.subtitle= ABCreateStringWithAddressDictionary(mark.addressDictionary,NO);
#pragma clang diagnostic pop
        
        NSLog(@"地理反编码%@",placemarks);
        [self.mapView selectAnnotation:[self.mapView.annotations firstObject] animated:YES];
    }];
}

@end
