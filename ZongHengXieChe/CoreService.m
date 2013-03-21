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
#import "User.h"

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
    
    [_myOrdering release];
    [_myCar release];
    [_locationManager release];
    [_currentCity release];
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

- (id)init
{
    [self loadUserFromLocal];
    self.myCar = [[CarInfo alloc] init];
    return self;
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

- (BOOL)isGPSValid
{
    return [CLLocationManager locationServicesEnabled];
}

- (void)setLocationUpdates:(BOOL)updateStatus
{
    if (updateStatus) {
        [_locationManager startUpdatingLocation];
    }else{
        [_locationManager stopUpdatingLocation];
    }
}

- (CLLocation *)getMyCurrentLocation
{
    [self startLocationManger];
    
    return _myCurrentLocation;
}

- (NSString *)getCurrentCity
{
    if (_currentCity) {
        return _currentCity;
    }else{
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        if ([userdefaults objectForKey:@"CURRENT_CITY"]) {
            self.currentCity = [userdefaults objectForKey:@"CURRENT_CITY"];
            return self.currentCity;
        }
        return @"上海";
    }
}

- (void)setCurrentCity:(NSString *)currentCity
{
    if (_currentCity) {
        if (_currentCity != currentCity) {
            [_currentCity release];
        }
    }
    _currentCity = [currentCity retain];
}

- (void)setCurrentUser:(User *)currentUser
{
    if (currentUser) {
        if (_currentUser) {
            if (_currentUser != currentUser) {
                [_currentUser release];
            }
        }
        _currentUser = [currentUser retain];
        [self saveUserToLocal];
    }
    
}

- (void)saveUserToLocal
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:self.currentUser.uid forKey:UserIdKey];
    [userdefaults setObject:self.currentUser.username forKey:UserNameKey];
    [userdefaults setObject:self.currentUser.truename forKey:UserTruenameKey];
    [userdefaults setObject:self.currentUser.email  forKey:UserEmailKey];
    [userdefaults setObject:self.currentUser.mobile forKey:UserMobileKey];
    [userdefaults setObject:self.currentUser.prov   forKey:UserProvKey];
    [userdefaults setObject:self.currentUser.city forKey:UserCityKey];
    [userdefaults setObject:self.currentUser.area forKey:UserAreaKey];
    [userdefaults setObject:self.currentUser.password forKey:UserPasswordKey];
    [userdefaults setObject:self.currentUser.token forKey:UserTokenKey];
    
    [userdefaults synchronize];
}

- (void)loadUserFromLocal
{
    if (!_currentUser) {
        _currentUser = [[User alloc] init];
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    _currentUser.uid = [userdefaults objectForKey:UserIdKey];
    _currentUser.username = [userdefaults objectForKey:UserNameKey];
    _currentUser.truename = [userdefaults objectForKey:UserTruenameKey];
    _currentUser.email = [userdefaults objectForKey:UserEmailKey];
    _currentUser.mobile = [userdefaults objectForKey:UserMobileKey];
    _currentUser.prov  =[userdefaults objectForKey:UserProvKey];
    _currentUser.city = [userdefaults objectForKey:UserCityKey];
    _currentUser.area = [userdefaults objectForKey:UserAreaKey];
    _currentUser.password = [userdefaults objectForKey:UserPasswordKey];
    _currentUser.token = [userdefaults objectForKey:UserTokenKey];
}

- (void)UserLogout
{
    self.currentUser = [[User alloc] init];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults removeObjectForKey:UserIdKey];
    [userdefaults removeObjectForKey:UserNameKey];
    [userdefaults removeObjectForKey:UserTruenameKey];
    [userdefaults removeObjectForKey:UserEmailKey];
    [userdefaults removeObjectForKey:UserMobileKey];
    [userdefaults removeObjectForKey:UserProvKey];
    [userdefaults removeObjectForKey:UserCityKey];
    [userdefaults removeObjectForKey:UserAreaKey];
    [userdefaults removeObjectForKey:UserPasswordKey];
    [userdefaults removeObjectForKey:UserTokenKey];
    
    [userdefaults synchronize];
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
//        DLog(@"%d",[self.networkQueue operationCount]);
        completionHandler(responseString);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        DLog(@"%@",[error description]);
        if (errorHandler) {
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
        if (errorHandler) {
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
        
        if ([childElement elementsForName:@"id"] && [propertyList containsObject:@"uid"]) {
            id propertyValue = [[[childElement elementsForName:@"id"] objectAtIndex:0]stringValue];
            [obj setValue:propertyValue forKey:@"uid"];
        }
        
        for (NSString *propertyName in propertyList) {
            if ([childElement elementsForName:propertyName]) {
                id propertyValue = [[[childElement elementsForName:propertyName] objectAtIndex:0]stringValue];
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


- (void)loginInBackgroundwithCompletionBlock:(void (^)(id data))completionHandler
{
    NSMutableDictionary *paramsDic = [[[NSMutableDictionary alloc] init] autorelease];
    [paramsDic setObject:_currentUser.username forKey:@"username"];
    [paramsDic setObject:_currentUser.password forKey:@"password"];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/public/applogincheck"
                                      withParams:paramsDic
                             withCompletionBlock:^(id data) {
                                 //                                     DLog(@"%@",data);
                                 NSDictionary *dic = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[dic objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 NSString *token = [[[dic objectForKey:@"XML"] objectForKey:@"tolken"] objectForKey:@"text"];
                                 NSString *desc = [[[dic objectForKey:@"XML"] objectForKey:@"desc"] objectForKey:@"text"];
                                 
                                 [_delegate didLoginBackground:status withMessage:desc];
                                 
                                 
                                 if ([status isEqualToString:@"0"]) {
                                     User *currentUser = [[User alloc]init];
                                     [currentUser setUid:[[[dic objectForKey:@"XML"] objectForKey:@"uid"] objectForKey:@"text"]];
                                     [currentUser setUsername:[paramsDic objectForKey:@"username"]];
                                     [currentUser setPassword:[paramsDic objectForKey:@"password"]];
                                     [currentUser setTruename:[[[dic objectForKey:@"XML"] objectForKey:@"truename"] objectForKey:@"text"]];
                                     [currentUser setToken:token];
                                     [currentUser setEmail:[[[dic objectForKey:@"XML"] objectForKey:@"email"] objectForKey:@"text"]];
                                     [currentUser setMobile:[[[dic objectForKey:@"XML"] objectForKey:@"mobile"] objectForKey:@"text"]];
                                     [currentUser setProv:[[[dic objectForKey:@"XML"] objectForKey:@"prov"] objectForKey:@"text"]];
                                     [currentUser setCity:[[[dic objectForKey:@"XML"] objectForKey:@"city"] objectForKey:@"text"]];
                                     [currentUser setArea:[[[dic objectForKey:@"XML"] objectForKey:@"area"] objectForKey:@"text"]];
                                     [[CoreService sharedCoreService] setCurrentUser:currentUser];
                                     [currentUser release];
                                 }
                                 
                                 if (completionHandler) {
                                     completionHandler(status);
                                 }
                                 
                             }    withErrorBlock:^(NSError *error) {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败请稍候再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                 [alert show];
                                 [alert release];
                             }];

}


- (void)loginInBackground
{
    NSMutableDictionary *paramsDic = [[[NSMutableDictionary alloc] init] autorelease];
    [paramsDic setObject:_currentUser.username forKey:@"username"];
    [paramsDic setObject:_currentUser.password forKey:@"password"];
    [[CoreService sharedCoreService] loadHttpURL:@"http://www.xieche.net/index.php/public/applogincheck"
                                      withParams:paramsDic
                             withCompletionBlock:^(id data) {
                                 DLog(@"user login: %@",data);
                                 NSDictionary *dic = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[dic objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 NSString *token = [[[dic objectForKey:@"XML"] objectForKey:@"tolken"] objectForKey:@"text"];
                                 NSString *desc = [[[dic objectForKey:@"XML"] objectForKey:@"desc"] objectForKey:@"text"];
                                 
                                 if ([status isEqualToString:@"0"]) {
                                     User *currentUser = [[CoreService sharedCoreService] currentUser];
                                     //                                     [currentUser setUid:[[[dic objectForKey:@"XML"] objectForKey:@"uid"] objectForKey:@"text"]];
                                     [currentUser setUsername:[paramsDic objectForKey:@"username"]];
                                     [currentUser setPassword:[paramsDic objectForKey:@"password"]];
                                     [currentUser setToken:token];
                                     
//                                     [currentUser setTruename:[[[dic objectForKey:@"XML"] objectForKey:@"truename"] objectForKey:@"text"]];
//                                     [currentUser setEmail:[[[dic objectForKey:@"XML"] objectForKey:@"email"] objectForKey:@"text"]];
//                                     [currentUser setMobile:[[[dic objectForKey:@"XML"] objectForKey:@"mobile"] objectForKey:@"text"]];
//                                     [currentUser setProv:[[[dic objectForKey:@"XML"] objectForKey:@"prov"] objectForKey:@"text"]];
//                                     [currentUser setCity:[[[dic objectForKey:@"XML"] objectForKey:@"city"] objectForKey:@"text"]];
//                                     [currentUser setArea:[[[dic objectForKey:@"XML"] objectForKey:@"area"] objectForKey:@"text"]];
                                 }
                                 
                                 [_delegate didLoginBackground:status withMessage:desc];
                                 
                             }    withErrorBlock:^(NSError *error) {
                                 [_delegate didLoginBackground:@"-1" withMessage:@"出错"];
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败请稍候再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                 [alert show];
                                 [alert release];
                             }];
}


@end
