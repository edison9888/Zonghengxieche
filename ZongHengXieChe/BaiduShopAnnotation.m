//
//  BaiduShopAnnotationView.m
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-9.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "BaiduShopAnnotation.h"

@implementation BaiduShopAnnotation
- (void)dealloc
{
    [self.shop release];
    [super dealloc];
}


- (id)initWithShopInfo:(Shop *)shop
{
    self.shop = shop;
    if ([super init]) {
        
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
