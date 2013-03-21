//
//  Brand.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CarInfo.h"

@implementation CarInfo

- (void)dealloc
{
    [_brand_id release];
    [_word release];
    [_brand_name release];
    [_series_id release];
    [_series_name release];
    [_model_id release];
    [_model_name release];
      
    [_brand_logo release];
    [_u_c_id release];
    [_car_name release];
    [_car_number release];
    [_s_pro release];
    [_create_time release];
    
    [super dealloc];
}

@end
