//
//  CouponCell.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "BaseViewController.h"


@interface CouponCell : UITableViewCell

@property (nonatomic, assign) enum ENTRANCE entrance;
@property (nonatomic, strong) Coupon *coupon;
- (void)applyCell:(Coupon *)coupon;
@end
