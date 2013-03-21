//
//  Brand.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfo : NSObject

@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *brand_name;

@property (nonatomic, copy) NSString *series_id;
@property (nonatomic, copy) NSString *series_name;

@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *model_name;

//我的车辆
@property (nonatomic, copy) NSString *brand_logo;
@property (nonatomic, copy) NSString *u_c_id;
@property (nonatomic, copy) NSString *car_name;
@property (nonatomic, copy) NSString *car_number;
@property (nonatomic, copy) NSString *s_pro;
@property (nonatomic, copy) NSString *create_time;


@end
