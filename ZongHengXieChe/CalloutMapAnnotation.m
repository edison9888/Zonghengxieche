//
//  CalloutMapAnnotation.m
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation


- (id)initWithLatitude:(double)lat andLongitude:(double)lon
{
    return  self;
}

- (void)dealloc
{
    [_shop release];
    [super dealloc];
}

- (id)initWithShopInfo:(Shop *)shop
{
    self = [super init];
    if (self) {
        self.shop = shop;
    }
    return self;
}
- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = self.shop.latitude;
    theCoordinate.longitude = self.shop.longitude;
    return theCoordinate;
}

- (NSString *)title
{
    //    return _shop.shop_name;
    return @"         ";
}

@end
