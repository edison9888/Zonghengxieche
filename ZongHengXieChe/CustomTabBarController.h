//
//  CustomTabBarController.h
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController<UIAlertViewDelegate>

- (UIViewController *)currentViewController;
- (void)setSelectedTab:(NSUInteger)index;
- (NSUInteger)getTabClickCount:(NSUInteger)index;
- (void)saveState:(NSInteger)locatIndex withFreshTagIndexArray:(NSArray *)indexArray;
- (void)resumeState;
- (void)hideTabbar:(BOOL)hiden;
@end
