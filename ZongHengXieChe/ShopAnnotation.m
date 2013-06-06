//
//  ShopPinAnnotation.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-27.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ShopAnnotation.h"

@implementation ShopAnnotation

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

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return _shop.shop_name;
}

// optional
- (NSString *)subtitle
{
    return _shop.shop_address;
}
@end
