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

@property (nonatomic, strong) NSString  *area;
@property (nonatomic, strong) NSString  *modelId;
@property (nonatomic, strong) NSMutableDictionary *argumentsDic;

@property (nonatomic, assign) enum ENTRANCE entrance;

- (IBAction)btnPressed:(UIButton *)btn;
- (IBAction)hideSearchMenu;
- (IBAction)couponBtnPressed:(UIButton *)btn;
- (IBAction)footBtnsPressed:(UIButton *)sender;
- (IBAction)carTypeSearch:(UIButton *)btn;
- (IBAction)hideSearchMenuView;
- (IBAction)btnsOfCouponKindMenuPressed:(UIButton *)btn;

@end
