//
//  Area.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-16.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Region.h"

@implementation Region

- (void)dealloc
{
    [_uid release];
    [_region_name release];
    
    [super dealloc];
}


@end
