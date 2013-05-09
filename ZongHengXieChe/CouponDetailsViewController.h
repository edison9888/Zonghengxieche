//
//  CouponDetailsViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Coupon.h"
@interface CouponDetailsViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString *coupon_id;
@property (nonatomic, assign) enum ENTRANCE entrance;
@property (nonatomic, strong) NSString *coupon_type;


@end
