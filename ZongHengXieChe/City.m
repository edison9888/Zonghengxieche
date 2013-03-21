//
//  City.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-16.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "City.h"

@implementation City

- (void)dealloc
{
    [_uid release];
    [_city_name release];
    
    [super dealloc];
}

@end
