//
//  CoreService.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "User.h"
#import "CarInfo.h"
#import "Ordering.h"
#import "City.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "BMapKit.h"

@protocol UserApiDelegate
@optional
- (void)didLoginBackground:(NSString *)status withMessage:(NSString *)resultMsg;
- (void)didFindCurrentPlacemark:(MKPlacemark *)placemark;
- (void)didTokenExpired;

@end

@interface CoreService : NSObject <CLLocationManagerDelegate, UserApiDelegate, MKReverseGeocoderDelegate>
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) ASINetworkQueue  *networkQueue;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) CarInfo *myCar;
@property (nonatomic, strong) Ordering *myOrdering;
@property (nonatomic, strong) City *currentSelectedCity;
@property (nonatomic, strong) NSString *currentLocationCityName;

+ (CoreService *)sharedCoreService;
- (CLLocation *)getMyCurrentLocation;
- (void)startLocationManger;
- (void)setLocationUpdates:(BOOL)updateStatus;
- (NSString *)getCurrentCity;

- (void)loadHttpURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler;
- (void)loadDataWithURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler;

- (NSMutableArray *)convertXml2Obj:(NSString *)xmlString withClass:(Class)clazz;
- (NSDictionary *)convertXml2Dic:(NSString *)xmlString withError:(NSError **)errorPointer;

- (NSMutableArray *)getPropertyList:(Class)clazz;

- (BOOL)isGPSValid;

- (NSArray *)getPlateProvinceArray;
- (NSString *)getCurrentAddress;
- (void)saveUserToLocal;
- (void)UserLogout;
- (NSString *)getToken:(UIViewController *)viewController;

@end
