//
//  CalloutMapAnnotation.h
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "Shop.h"

@interface CalloutMapAnnotation : NSObject<BMKAnnotation>
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) Shop   *shop;

- (id)initWithLatitude:(double)lat andLongitude:(double)lon;

@end
