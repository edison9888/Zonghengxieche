//
//  Ordering.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-17.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeSale.h"
@interface Ordering : NSObject
//required
@property (nonatomic, copy) NSString *order_date;
@property (nonatomic, copy) NSString *order_hours;
@property (nonatomic, copy) NSString *order_minute;
@property (nonatomic, copy) NSMutableString *select_services;
@property (nonatomic, copy) NSString *timesaleversion_id;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *truename;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *cardqz;
@property (nonatomic, copy) NSString *licenseplate;

//optional
@property (nonatomic, copy) NSString *tolken;  //传表示登陆下订 不传表示下模糊单
@property (nonatomic, copy) NSString *model_id; //车型ID
@property (nonatomic, copy) NSString *u_c_id; //我的车辆ID
@property (nonatomic, copy) NSString *brand_id; //品牌ID
@property (nonatomic, copy) NSString *series_id; //车系ID
@property (nonatomic, copy) NSString *miles; //行驶里数
@property (nonatomic, copy) NSString *car_sn; //车辆识别码
@property (nonatomic, copy) NSString *remark; //备注;


//我的订单
@property (nonatomic, copy) NSString *order_count;//  订单数量
@property (nonatomic, copy) NSString *uid;      // 订单ID
@property (nonatomic, copy) NSString *order_id; //处理后的订单号 用于页面显示
@property (nonatomic, copy) NSString *order_type; // 订单类型 1普通订单；2优惠券订单
@property (nonatomic, copy) NSString *create_time;//     下定时间
@property (nonatomic, copy) NSString *order_time;//      预约时间
@property (nonatomic, copy) NSString *iscomment;//      是否评论
@property (nonatomic, copy) NSString *order_state;//  订单状态 '0'=>'等待处理','1'=>'预约已确认','2'=>'预约已完成','-1'=>'作废预约',
@property (nonatomic, copy) NSString *order_state_str;// 订单状态 文字显示
@property (nonatomic, copy) NSString *complain_state;//   投诉状态  '0'=>'无','1'=>'投诉中','2'=>'结束投诉'
@property (nonatomic, copy) NSString *product_sale;//   零件折扣
@property (nonatomic, copy) NSString *workhours_sale;//   工时折扣
@property (nonatomic, copy) NSString *shop_name;//
@property (nonatomic, copy) NSString *shop_maps;
@property (nonatomic, copy) NSString *shop_address;
@property (nonatomic, copy) NSString *order_verify;//订单验证编号 （如果是优惠券订单才有这个字段 ）
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *detail_html;


@property (nonatomic, copy) NSMutableArray *serviceArray;
@property (nonatomic, strong) TimeSale    *selectedTimeSale;


- (id)init;
@end
