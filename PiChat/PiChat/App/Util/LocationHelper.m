//
//  LocationHelper.m
//  PiChat
//
//  Created by pi on 16/3/7.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "LocationHelper.h"
@import CoreLocation;

@interface LocationHelper ()<CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *manager;
@property (copy,nonatomic) LocationResultBlock callback;

@end

@implementation LocationHelper
+(instancetype)sharedLocationHelper{
    static id _locationHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationHelper=[LocationHelper new];
    });
    return _locationHelper;
}

-(CLLocationManager *)manager{
    if(!_manager){
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy=kCLLocationAccuracyBest;
        _manager.distanceFilter=10;
        [_manager requestWhenInUseAuthorization];
    }
    return _manager;
}

-(void)getCurrentLocation:(LocationResultBlock)callback{
    [self.manager startUpdatingLocation];
    self.callback=callback;
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location= [locations lastObject];
    if(fabs(location.verticalAccuracy)<=10){
        [self.manager stopUpdatingLocation];
        self.callback(location,nil);
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.callback(nil,error);
}
@end
