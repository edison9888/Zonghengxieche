//
//  ShopDetailsViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-7.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
#import "Shop.h"
#import "CouponBtnView.h"
#import "TimeSaleView.h"

@interface ShopDetailsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, CouponBtnViewDelegate, TimeSaleDelegate>

@property (nonatomic, strong) Shop *shop;
@property (nonatomic, strong) NSString *shop_id;

- (IBAction)showComment;
- (IBAction)pushToLocation;
@end



#import "Shop.h"
@interface TitleCell : UITableViewCell

@property (nonatomic, strong) Shop *shop;

- (void)applyCell:(Shop *)shop;
@end