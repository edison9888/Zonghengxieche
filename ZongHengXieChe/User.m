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
    [self.username release];
    [self.password release];
    [self.token release];
    
    [super dealloc];
}

@end
