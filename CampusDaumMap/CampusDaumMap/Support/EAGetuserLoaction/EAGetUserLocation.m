//
//  EAGetUserLoaction.m
//  EasyToOrder
//
//  Created by user on 2018. 5. 31..
//  Copyright © 2018년 user. All rights reserved.
//

#import "EAGetUserLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface EAGetUserLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;

@end

@implementation EAGetUserLocation

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"getCurrentUserLocation init called");
        [self getCurrentUserLocation];
    }
    return self;
}

- (void)getCurrentUserLocation {
    NSLog(@"getCurrentUserLocation called");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"[error] get current location failed .... %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    CLLocation *currentLocation = [locations lastObject];
    
    [self.delegate getCurrentUserLocationWithCurrentLocation:currentLocation];
    
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
//            [self.delegate getCurrentUserLocationWithCurrentLocation:currentLocation withAddr:self.placemark.name];
        } else {
        }
    }];
}

@end
