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
    
    [super dealloc];
}

@end
