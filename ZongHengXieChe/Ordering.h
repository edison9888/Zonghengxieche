//
//  Ordering.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-17.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ordering : NSObject
//required
@property (nonatomic, copy) NSString *order_date;
@property (nonatomic, copy) NSString *order_hours;
@property (nonatomic, copy) NSString *order_minute;
@property (nonatomic, copy) NSString *select_services;
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



@end
