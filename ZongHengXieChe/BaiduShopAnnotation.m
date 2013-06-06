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
//    return _shop.shop_name;
    return @"         ";
}

// optional
- (NSString *)subtitle
{
    return @"                        ";
    
    if (!self.shop.workhours_sale || [self.shop.workhours_sale isEqualToString:@""]) {
        return [NSString stringWithFormat:@"暂无工时折扣"];
    }else{
        return [NSString stringWithFormat:@"工时费%@起", self.shop.workhours_sale];
    }
}
@end
