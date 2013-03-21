//
//  Coupon.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-14.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Coupon.h"
#import "CoreService.h"

@implementation Coupon


- (void)dealloc
{
    [_uid release];
    [_coupon_name release];
    [_distance release];
    [_distanceFromMe release];
    [_coupon_amount release];
    [_cost_price release];
    [_pay_count release];
    [_coupon_logo release];
    [_coupon_type release];
    [_end_time release];
    
    [_coupon_pic release];
    [_coupon_des release];
    [_coupon_summary release];
    [_shop_id release];
    [_shop_name release];
    [_shop_address release];
    [_shop_maps release];
    [_coupon_code release];
    [_membercoupon_id release];
    
    [_state_str release];
    [_coupon_id release];
    [_mobile release];
    [_start_time release];
    
    
    [super dealloc];
}

- (void)setShop_maps:(NSString *)shop_maps
{
    if (_shop_maps != shop_maps){
        if (_shop_maps) {
            [_shop_maps release];
        }
        _shop_maps = [shop_maps copy];
    }
    NSArray *stringArray = [self.shop_maps componentsSeparatedByString:@","];
    if ([stringArray count]>0) {
        double longitude = [[stringArray objectAtIndex:0] doubleValue];
        double latitude = [[stringArray objectAtIndex:1] doubleValue];
        
        CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
        if (myCurrentLocation) {
            self.distanceFromMe = [NSString stringWithFormat:@"%f",[myCurrentLocation distanceFromLocation:[[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease]]];
        }
    }
}


@end
