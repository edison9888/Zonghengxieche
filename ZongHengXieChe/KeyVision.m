//
//  KeyVision.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-1.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "KeyVision.h"

@implementation KeyVision

- (void)dealloc
{
    [_pic release];
    [_type release];
    [_uid release];
    [_kvImage release];
    
    [super dealloc];
}


- (void)setPic:(NSString *)pic
{
    if (_pic != pic){
        if (_pic) {
            [_pic release];
        }
        if (![pic hasPrefix:@"http://"]) {
            _pic = [[NSString alloc] initWithFormat:@"http://%@",pic];
        }else{
            _pic = [pic copy];
        }
    }
}


@end
