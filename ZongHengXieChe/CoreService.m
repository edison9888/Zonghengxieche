//
//  CoreService.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CoreService.h"
#import "GDataXMLNode.h"
#import "XMLReader.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import <objc/runtime.h>

#define MaxConcurrentOperationCount 3

@interface CoreService()
{
    CLLocationManager *_locationManager;
    CLLocation *_myCurrentLocation;
}
@property (nonatomic, strong) ASINetworkQueue  *networkQueue;

@end

@implementation CoreService

- (void)dealloc
{
    if (self.networkQueue) {
        [self.networkQueue cancelAllOperations];
        [self.networkQueue release];
    }
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
    
//    DLog(@"%d ,%f , %f", [locations count], _myCurrentLocation.coordinate.longitude, _myCurrentLocation.coordinate.latitude);
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
//    DLog("@didUpdateToLocation");
    if (_myCurrentLocation != nil) {
        [_myCurrentLocation release];
    }
    _myCurrentLocation = [newLocation retain];
    
//    DLog(@"longitude=%f , latitude=%f", _myCurrentLocation.coordinate.longitude, _myCurrentLocation.coordinate.latitude);
}

- (void)getStoredInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.currentUser = [userDefaults objectForKey:NSLocalizedString(@"CURRENT_USER", nil)];

    
}

- (void)loadHttpURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler
{
    if (!self.networkQueue) {
        self.networkQueue = [[ASINetworkQueue alloc] init];
        [self.networkQueue setMaxConcurrentOperationCount:MaxConcurrentOperationCount];
        [self.networkQueue setShouldCancelAllRequestsOnFailure:NO];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request;
    if (dic && [dic.allKeys count]>0) {
        request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        for (NSString *key in dic.allKeys) {
            [((ASIFormDataRequest *)request) addPostValue:[dic objectForKey:key] forKey:key];
        }
    }else{
        request = [ASIHTTPRequest requestWithURL:url];
    }
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        DLog(@"%d",[self.networkQueue operationCount]);
        completionHandler(responseString);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        DLog(@"%@",[error description]);
        if (error) {
            errorHandler(error);
        }
        
    }];
    [self.networkQueue addOperation:request];
    DLog(@"%d",[self.networkQueue operationCount]);
    
    if ([self.networkQueue isSuspended]) {
        [self.networkQueue go];
    }
}



- (void)loadDataWithURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler
{
    if (!self.networkQueue) {
        self.networkQueue = [[ASINetworkQueue alloc] init];
        [self.networkQueue setMaxConcurrentOperationCount:MaxConcurrentOperationCount];
        [self.networkQueue setShouldCancelAllRequestsOnFailure:NO];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request;
    if (dic && [dic.allKeys count]>0) {
        request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        for (NSString *key in dic.allKeys) {
            [((ASIFormDataRequest *)request) addPostValue:[dic objectForKey:key] forKey:key];
        }
    }else{
        request = [ASIHTTPRequest requestWithURL:url];
    }
    
    [request setCompletionBlock:^{
        
        completionHandler([request responseData]);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        DLog(@"%@",[error description]);
        if (error) {
            errorHandler(error);
        }
        
    }];
    [self.networkQueue addOperation:request];
    DLog(@"%d",[self.networkQueue operationCount]);
    
    if ([self.networkQueue isSuspended]) {
        [self.networkQueue go];
    }
}

- (NSMutableArray *)getPropertyList:(Class)clazz
{
    NSMutableArray *propertyArray = [[[NSMutableArray alloc] init] autorelease];
    unsigned int nCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &nCount);
    for (int i = 0; i < nCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",property_getName(property)];
        [propertyArray addObject:propertyName];
        //        DLog(@"class name is = %s && attr = %s", property_getName(property), property_getAttributes(property));
    }
    return propertyArray;
}


- (NSMutableArray *)convertXml2Obj:(NSString *)xmlString withClass:(Class)clazz
{
    NSMutableArray *objectArray = [[[NSMutableArray alloc] init] autorelease];
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:1 error:&error];
    GDataXMLElement *rootElement = [document rootElement];
    DLog(@"rootElement name = %@ , childrenCount = %d", [rootElement name], [rootElement childCount]);
    
    NSArray *childrenArray = [rootElement children];
    for (GDataXMLElement *childElement in childrenArray) {
        id obj = [[clazz alloc] init];
        NSMutableArray *propertyList = [self getPropertyList:clazz];
        for (NSString *propertyName in propertyList) {
            id propertyValue = [[[childElement elementsForName:propertyName] objectAtIndex:0]stringValue];
            if (propertyValue) {
                [obj setValue:propertyValue forKey:propertyName];
            }
            
        }
        [objectArray addObject:obj];
        [obj release];
    }
    return objectArray;
}


- (NSDictionary *)convertXml2Dic:(NSString *)xmlString withError:(NSError **)errorPointer
{
    return [XMLReader dictionaryForXMLString:xmlString error:errorPointer];
}


@end
