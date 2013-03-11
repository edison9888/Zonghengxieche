//
//  ShopDetails.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-12.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ShopDetails.h"

@implementation ShopDetails

- (void)dealloc
{
    [_shopid release];
    [_shop_name release];
    [_shop_address release];
    [_shop_account release];
    [_shop_maps release];
    [_logo release];
    [_comment_rate release];
    [_comment_number release];
    [_comment_id release];
    [_user_name release];
    [_comment release];
    [_comment_type release];
    [_timesale_id release];
    [_week release];
    [_begin_time release];
    [_end_time release];
    [_timesaleversion_id release];
    [_product_sale release];
    [_workhours_sale release];
    [_memo release];
    [_coupon_id release];
    
    
    [super dealloc];
}

- (NSString *)getWeekday
{
    if (_week) {
        NSMutableString *str = [[[NSMutableString alloc] init] autorelease];
        if ([_week rangeOfString:@"1"].location != NSNotFound) {
            if ([str length]>0) {
                [str appendFormat:@"、"];
            }
            [str appendFormat:@"周一"];
        }
        if ([_week rangeOfString:@"2"].location != NSNotFound) {
            if ([str length]>0) {
                [str appendFormat:@"、"];
            }
            [str appendFormat:@"周二"];
        }
        if ([_week rangeOfString:@"3"].location != NSNotFound) {
            if ([str length]>0) {
                [str appendFormat:@"、"];
            }
            [str appendFormat:@"周三"];
        }
        if ([_week rangeOfString:@"4"].location != NSNotFound) {
            if ([str length]>0) {
                [str appendFormat:@"、"];
            }
            [str appendFormat:@"周四"];
        }
        if ([_week rangeOfString:@"5"].location != NSNotFound) {
            if ([str length]>0) {
                [str appendFormat:@"、"];
            }
            [str appendFormat:@"周五"];
        }
        if ([_week rangeOfString:@"6"].location != NSNotFound) {
            if ([str length]>0) {
                [str appendFormat:@"、"];
            }
            [str appendFormat:@"周六"];
        }
        if ([_week rangeOfString:@"0"].location != NSNotFound) {
            if ([str length]>0) {
                [str appendFormat:@"、"];
            }
            [str appendFormat:@"周日"];
        }
        return str;
    }
    return @"";
}


@end
