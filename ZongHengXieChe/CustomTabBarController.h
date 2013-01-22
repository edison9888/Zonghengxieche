//
//  CustomTabBarController.h
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController

- (UIViewController *)currentViewController;
- (void)setSelectedTab:(NSUInteger)index;
- (NSUInteger)getTabClickCount:(NSUInteger)index;
- (void) saveState:(NSInteger)locatIndex withNewTagIndexArray:(NSArray *)indexArray;
- (void) resumeState;
@end
