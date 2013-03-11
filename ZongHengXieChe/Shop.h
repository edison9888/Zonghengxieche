//
//  Shop.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-25.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface Shop : NSObject

@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *show_title;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_address;
@property (nonatomic, copy) NSString *shop_phone;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *comment_rate;
@property (nonatomic, copy) NSString *comment_number;
@property (nonatomic, copy) NSString *product_sale;
@property (nonatomic, copy) NSString *workhours_sale;
@property (nonatomic, copy) NSString *shop_class;

@property (nonatomic, copy) UIImage  *logoImage;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationDistance distanceFromMyLocation;

- (void)resetLogoImage:(void (^)(UIImage *image))completionHandler;

@end
