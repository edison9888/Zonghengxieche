//
//  ShopDetails.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-12.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface ShopDetails : NSObject

@property (nonatomic, copy) NSString *shopid;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_class;
@property (nonatomic, copy) NSString *shop_address;
@property (nonatomic, copy) NSString *shop_account;
@property (nonatomic, copy) NSString *shop_maps;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *comment_rate;
@property (nonatomic, copy) NSString *comment_number;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *comment_type;
@property (nonatomic, copy) NSString *timesale_id;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *timesaleversion_id;
@property (nonatomic, copy) NSString *product_sale;
@property (nonatomic, copy) NSString *workhours_sale;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *coupon_id;

@property (nonatomic, copy) NSString *coupon_count1;
@property (nonatomic, copy) NSString *coupon1_id;
@property (nonatomic, copy) NSString *coupon1_name;
@property (nonatomic, copy) NSString *coupon_count2;
@property (nonatomic, copy) NSString *coupon2_id;
@property (nonatomic, copy) NSString *coupon2_name;

@property (nonatomic, copy) UIImage  *logoImage;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationDistance distanceFromMyLocation;

@property (nonatomic, strong) NSMutableArray *timesaleArray;



- (NSString *)getWeekday;

@end
