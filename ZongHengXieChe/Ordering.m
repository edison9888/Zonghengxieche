//
//  Ordering.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-17.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Ordering.h"

@implementation Ordering

- (void)dealloc
{
    [_order_date release];
    [_order_hours release];
    [_order_minute release];
    [_select_services release];
    [_timesaleversion_id release];
    [_shop_id release];
    [_truename release];
    [_mobile release];
    [_cardqz release];
    [_licenseplate release];
    
    //optional
    [_tolken release];  //传表示登陆下订 不传表示下模糊单
    [_model_id release]; //车型ID
    [_u_c_id release]; //我的车辆ID
    [_brand_id release]; //品牌ID
    [_series_id release]; //车系ID
    [_miles release]; //行驶里数
    [_car_sn release]; //车辆识别码
    [_remark release]; //备注 release];

    
    [_order_count release];//  订单数量
    [_uid release];      // 订单ID
    [_order_id release]; //处理后的订单号 用于页面显示
    [_order_type release]; // 订单类型 1普通订单；2优惠券订单
    [_create_time release];//     下定时间
    [_order_time release];//      预约时间
    [_iscomment release];//      是否评论
    [_order_state release];//  订单状态 '0'=>'等待处理','1'=>'预约已确认','2'=>'预约已完成','-1'=>'作废预约',
    [_order_state_str release];// 订单状态 文字显示
    [_complain_state release];//   投诉状态  '0'=>'无','1'=>'投诉中','2'=>'结束投诉'
    [_product_sale release];//   零件折扣
    [_workhours_sale release];//   工时折扣
    [_shop_name release];//
    [_order_verify release];//订单验证编号 （如果是优惠券订单才有这个字段 ）
    [_logo release];
    [_detail_html release];
    [_serviceArray release];
    [_selectedTimeSale release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _serviceArray = [[NSMutableArray alloc] init];
    }
    return  self;
}

@end
