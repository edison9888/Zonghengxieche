//
//  Shop.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-25.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Shop.h"
#import <CoreLocation/CoreLocation.h>
#import "CoreService.h"


@implementation Shop

- (void)dealloc
{
    [self.shop_id release];
    [self.show_title release];
    [self.shop_name release];
    [self.shop_address release];
    [self.shop_phone release];
    [self.area release];
    [self.logo release];
    [self.logoImage release];
    [self.region release];
    [self.comment_rate release];
    [self.comment_number release];
    [self.product_sale release];
    [self.workhours_sale release];
    [self.shop_class release];
    [self.have_coupon1 release];
    [self.have_coupon2 release];
    [self.model_id release];
    [self.shop_maps release];
    [self.distance release];
    [super dealloc];
}

- (void)setArea:(NSString *)area
{
    if (_area != area){
        if (_area) {
            [_area release];
        }
        _area = [area copy];
    }
    NSArray *stringArray = [self.area componentsSeparatedByString:@","];
    if ([stringArray count]>0) {
        self.longitude = [[stringArray objectAtIndex:0] doubleValue];
        self.latitude = [[stringArray objectAtIndex:1] doubleValue];
        [self resetDistance];
    }
}

- (void)resetDistance
{
    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
    if (myCurrentLocation) {
        self.distanceFromMyLocation = [myCurrentLocation distanceFromLocation:[[[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude] autorelease]];
    }
}

- (void)resetLogoImage:(void (^)(UIImage *image))completionHandler
{
    if (self.logo) {
        [[CoreService sharedCoreService]loadDataWithURL:self.logo
                                             withParams:nil
                                    withCompletionBlock:^(id data) {
                                        self.logoImage = [UIImage imageWithData:data];
                                        if (completionHandler) {
                                            completionHandler(self.logoImage);
                                        }
                                    } withErrorBlock:nil];
    }
}


@end
