//
//  Coupon.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-14.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *coupon_name;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *distanceFromMe;
@property (nonatomic, copy) NSString *coupon_amount;
@property (nonatomic, copy) NSString *cost_price;
@property (nonatomic, copy) NSString *pay_count;
@property (nonatomic, copy) NSString *coupon_logo;
@property (nonatomic, copy) NSString *coupon_type;
@property (nonatomic, copy) NSString *end_time;

//详情
@property (nonatomic, copy) NSString *coupon_pic;
@property (nonatomic, copy) NSString *coupon_des;
@property (nonatomic, copy) NSString *coupon_summary;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_address;
@property (nonatomic, copy) NSString *shop_maps;


//我的优惠券
@property (nonatomic, copy) NSString *is_use;
@property (nonatomic, copy) NSString *is_pay;
@property (nonatomic, copy) NSString *is_overtime;
@property (nonatomic, copy) NSString *coupon_code;
@property (nonatomic, copy) NSString *membercoupon_id;

//我的优惠券详情
@property (nonatomic, copy) NSString *state_str;
@property (nonatomic, copy) NSString *coupon_id;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *start_time;



@end
