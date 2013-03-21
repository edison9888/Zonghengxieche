//
//  TimeSale.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-21.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSale : NSObject

@property (nonatomic, copy) NSString *timesale_id;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *timesaleversion_id;
@property (nonatomic, copy) NSString *workhours_sale;
@property (nonatomic, copy) NSString *memo;


- (NSString *)getWeekday;

@end
