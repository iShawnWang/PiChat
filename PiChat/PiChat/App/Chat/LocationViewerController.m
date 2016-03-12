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
#import "MBProgressHUD+Addition.h"
#import "CommenUtil.h"
#import <Masonry.h>

@interface LocationViewerController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) CLGeocoder *geocoder;
@property (strong,nonatomic) CLLocationManager *manager;
@end

@implementation LocationViewerController

-(CLLocationManager *)manager{
    if(!_manager){
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
    }
    return _manager;
}

-(CLGeocoder *)geocoder{
    if(!_geocoder){
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.delegate=self;
    [self.view addSubview:self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if(self.action == LocationViewerActionPickLocation){
        [self addPickCancelBtn];
    }
}

-(void)addPickCancelBtn{
    //发送位置 Btn
    UIButton *pickBtn=[[UIButton alloc]init];
    [pickBtn setTitle:@"发送当前位置" forState:UIControlStateNormal];
    [pickBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    pickBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [pickBtn addTarget:self action:@selector(didPickLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickBtn];
    
    [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).offset(-8);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12);
    }];
    
    // 取消 Btn
    UIButton *cancelBtn=[[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [cancelBtn addTarget:self action:@selector(cancelPickLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(-8);
        make.trailing.equalTo(pickBtn.mas_leading).offset(-8);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12);
        make.width.equalTo(pickBtn);
    }];

}

-(void)didPickLocation{
    if(!self.location){
        return;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate locationViewerController:self didPickLocation:self.location];
}

-(void)cancelPickLocation{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.manager requestWhenInUseAuthorization];
}

-(void)showLocationPin{
    if(!self.location){
        @throw [NSException exceptionWithName:@"粑粑" reason:@"要显示 location 需设置 location = xxx" userInfo: nil];
        return;
    }
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

-(void)showUserLocation{
    self.mapView.showsUserLocation=YES;
}

#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    self.location=userLocation.location;
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
}


#pragma mark - 
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status==kCLAuthorizationStatusDenied){
        [CommenUtil showSettingAlertIn:self];
        return;
    }
    switch (self.action) {
        case LocationViewerActionPickLocation:
            [self showUserLocation];
            break;
        case LocationViewerActionView:
            [self showLocationPin];
            break;
    }
}
@end
