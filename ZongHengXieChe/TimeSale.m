//
//  TimeSale.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-21.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "TimeSale.h"

@implementation TimeSale

- (void)dealloc
{
    [_timesale_id release];
    [_week release];
    [_begin_time release];
    [_end_time release];
    [_timesaleversion_id release];
    [_workhours_sale release];
    [_memo release];
    
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
