//
//  CoreService.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import "CarInfo.h"
#import "Ordering.h"

@protocol UserApiDelegate
@optional
- (void)didLoginBackground:(NSString *)status withMessage:(NSString *)resultMsg;

@end

@interface CoreService : NSObject <CLLocationManagerDelegate, UserApiDelegate>
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) CarInfo *myCar;
@property (nonatomic, strong) Ordering *myOrdering;

+ (CoreService *)sharedCoreService;
- (CLLocation *)getMyCurrentLocation;
- (void)startLocationManger;
- (void)setLocationUpdates:(BOOL)updateStatus;
- (NSString *)getCurrentCity;

- (void)saveUserToLocal;

- (void)loadHttpURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler;
- (void)loadHttpURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler withUIViewController:(UIViewController *)vc;
- (void)loadDataWithURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler;

- (NSMutableArray *)convertXml2Obj:(NSString *)xmlString withClass:(Class)clazz;
- (NSDictionary *)convertXml2Dic:(NSString *)xmlString withError:(NSError **)errorPointer;

- (NSMutableArray *)getPropertyList:(Class)clazz;

- (BOOL)isGPSValid;

- (NSArray *)getPlateProvinceArray;
- (void)UserLogout;
- (NSString *)getToken:(UIViewController *)viewController;

@end
