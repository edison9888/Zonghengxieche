//
//  Shop.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-25.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Shop.h"

@implementation Shop

- (void)dealloc
{
    [self.shop_id release];
    [self.show_title release];
    [self.shop_name release];
    [self.shop_address release];
    [self.shop_phone release];
    [self.area release];
    [self.logo release];
    [self.region release];
    [self.comment_rate release];
    [self.comment_number release];
    [self.product_sale release];
    [self.workhours_sale release];

    [super dealloc];
}



@end
