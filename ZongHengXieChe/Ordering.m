//
//  Ordering.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-17.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Ordering.h"

@implementation Ordering

- (void)dealloc
{
    [_order_date release];
    [_order_hours release];
    [_order_minute release];
    [_select_services release];
    [_timesaleversion_id release];
    [_shop_id release];
    [_truename release];
    [_mobile release];
    [_cardqz release];
    [_licenseplate release];
    
    //optional
    [_tolken release];  //传表示登陆下订 不传表示下模糊单
    [_model_id release]; //车型ID
    [_u_c_id release]; //我的车辆ID
    [_brand_id release]; //品牌ID
    [_series_id release]; //车系ID
    [_miles release]; //行驶里数
    [_car_sn release]; //车辆识别码
    [_remark release]; //备注 release];

    [super dealloc];
}



@end
