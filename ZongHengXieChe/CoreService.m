//
//  CoreService.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CoreService.h"

@interface CoreService()
{
    CLLocationManager *_locationManager;
    CLLocation *_myCurrentLocation;
}

@end

@implementation CoreService

- (void)dealloc
{
    [_locationManager release];
    [super dealloc];
}


#pragma mark- custom methods

+ (CoreService *)sharedCoreService
{
    static CoreService *coreService = nil;
    if (!coreService) {
        coreService = [[CoreService alloc] init];
    }
    [coreService startLocationManger];
    [coreService getStoredInfo];
    return coreService;
}

- (void)startLocationManger
{
    if (![CLLocationManager locationServicesEnabled]) {
        DLog(@"位置服务不可用");
    }else{
        if (!_locationManager){
            _locationManager = [[CLLocationManager alloc] init];
            [_locationManager setDelegate:self];
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [_locationManager startUpdatingLocation];
        }
    }
}

- (CLLocation *)getMyCurrentLocation
{
    [self startLocationManger];
    
    return _myCurrentLocation;
}

#pragma mark- location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_myCurrentLocation != nil) {
        [_myCurrentLocation release];
    }
    _myCurrentLocation = [[locations lastObject] retain];
    
    DLog(@"%d ,%f , %f", [locations count], _myCurrentLocation.coordinate.longitude, _myCurrentLocation.coordinate.latitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"%@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if ( status == kCLAuthorizationStatusNotDetermined ) {
        DLog(@"1");
    }
    
    if ( status == kCLAuthorizationStatusRestricted ) {
        DLog(@"1");
    }
    
    if ( status == kCLAuthorizationStatusDenied ) {
        DLog(@"1");
    }
    
    if (status == kCLAuthorizationStatusAuthorized ) {
        DLog(@"1");
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DLog("@didUpdateToLocation");
    if (_myCurrentLocation != nil) {
        [_myCurrentLocation release];
    }
    _myCurrentLocation = [newLocation retain];
    
    DLog(@"longitude=%f , latitude=%f", _myCurrentLocation.coordinate.longitude, _myCurrentLocation.coordinate.latitude);
}

- (void)getStoredInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.currentUser = [userDefaults objectForKey:NSLocalizedString(@"CURRENT_USER", nil)];

    
}



@end
