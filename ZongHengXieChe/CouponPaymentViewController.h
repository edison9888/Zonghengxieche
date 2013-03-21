//
//  CouponPaymentViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-15.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "BaseViewController.h"
@interface CouponPaymentViewController : BaseViewController<UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) Coupon *coupon;

@end
