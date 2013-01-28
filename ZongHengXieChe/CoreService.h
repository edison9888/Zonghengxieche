//
//  CoreService.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CoreService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *shopArray;

+ (CoreService *)sharedCoreService;
- (CLLocation *)getMyCurrentLocation;
- (void)startLocationManger;
@end
