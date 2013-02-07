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
    [self.pic release];
    [self.type release];
    [self.uid release];
    [self.kvImage release];
    
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
