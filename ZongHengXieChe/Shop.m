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
    [_shop_id release];
    [_show_title release];
    [_shop_name release];
    [_shop_address release];
    [_shop_phone release];
    [_area release];
    [_logo release];
    [_logoImage release];
    [_region release];
    [_comment_rate release];
    [_comment_number release];
    [_product_sale release];
    [_workhours_sale release];
    [_shop_class release];
    [_have_coupon1 release];
    [_have_coupon2 release];
    [_model_id release];
    [_shop_maps release];
    [_distance release];
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
