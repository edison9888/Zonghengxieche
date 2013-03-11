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
@interface CoreService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) NSString *currentCity;


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
@end
