//
//  User.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-31.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "User.h"

@implementation User


- (void)dealloc
{
    [_uid release];
    [_username release];
    [_truename release];
    [_email release];
    [_mobile release];
    [_prov release];
    [_city release];
    [_area release];
    [_password release];
    [_token release];
    
    [super dealloc];
}

@end
