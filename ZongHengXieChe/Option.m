//
//  Option.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Option.h"

@implementation Option

- (void)dealloc
{
    [_icon release];
    [_title release];
    [_details release];

    [super dealloc];
}

@end
