//
//  CouponViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CouponViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

- (IBAction)btnPressed:(UIButton *)btn;
- (IBAction)hideSearchMenu;
- (IBAction)couponBtnPressed:(UIButton *)btn;

@end
