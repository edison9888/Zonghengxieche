//
//  CouponBtn.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-21.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CouponBtnViewDelegate
@optional
- (void)didCouponButtonPressed:(UIButton *)button;

@end

enum COUPON_TYPE{
    QUAN_TYPE = 1,
    TUAN_TYPE
};


@interface CouponBtnView : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) enum COUPON_TYPE type;

- (id)initCouponBtnViewWithFrame:(CGRect)frame withType:(enum COUPON_TYPE )type;
- (void)setTitle:(NSString *)titleString;
- (void)setCount:(NSString *)countNumber;

@end
