//
//  LocationUtil.m
//  wolaidai
//
//  Created by Seven on 4/17/15.
//  Copyright (c) 2015 welab. All rights reserved.
//

#import "LocationUtil.h"

@interface LocationUtil()

@property (nonatomic,copy) LocationBlock block;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *myGeocoder;

@property (nonatomic,assign) BOOL updateLocationLock;

@end

@implementation LocationUtil

+(instancetype)shareInstance
{
    static LocationUtil* util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[LocationUtil alloc]init];
    });
    return util;
}

- (id)init {
    self = [super init];
    if (self) {
        [CLLocationManager locationServicesEnabled];
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

-(void)requireCurrentLocationWithBlock:(LocationBlock)block
{
    self.block = block;
    [_locationManager startUpdatingLocation];
    self.updateLocationLock = YES;
}


- (void)locationManager:(CLLocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *) oldLocation;
{
    if (self.updateLocationLock) {
        [self startedReverseGeoderWithLocation:newLocation];
    }
    self.updateLocationLock = NO;
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    
    
    if ( [error code] == kCLErrorDenied ) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"打开\"定位服务\"以允许我们确定您的位置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请授权\"定位服务\"以允许我们确定您的位置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            NSURL *url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(void)startedReverseGeoderWithLocation:(CLLocation *)location{
    _myGeocoder = [[CLGeocoder alloc]init];
    
    [_myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            if (self.block) {
                self.block(NO,nil);
            }
        }else {
            if (self.block) {
                self.block(YES,[placemarks firstObject]);
                self.block = nil;
            }
        }
    }];
}
@end
