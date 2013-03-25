//
//  Service.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-17.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Service.h"

@implementation Service

- (void)dealloc
{
    [_service_id release];
    [_name release];
    [_allprice release];
    [_aftersaveprice release];
    [_saveprice release];

    [super dealloc];
}

@end
