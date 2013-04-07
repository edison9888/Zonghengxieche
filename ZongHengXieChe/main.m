//
//  main.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
#if defined ENVIRONMENT_DEVELOPMENT
        @try
        {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([MGAppDelegate class]));
        }
        @catch (NSException *e)
        {
            NSLog(@"EXCEPTION THROWN IN METHOD; %@ %@\n%@", [e name], [e reason], [e callStackSymbols]);
        }
#else
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#endif
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
