//
//  CoreService.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CoreService.h"

@implementation CoreService


+ (CoreService *)sharedCoreService
{
    static CoreService *coreService = nil;
    if (!coreService) {
        coreService = [[CoreService alloc] init];
    }
    return coreService;
}

@end
