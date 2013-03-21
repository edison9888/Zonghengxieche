//
//  Points.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-13.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Points.h"

@implementation Points

- (void)dealloc
{
    [_order_id release];
    [_point_number release];
    [_memo release];
    
    [super dealloc];
}


@end
