//
//  BaiduShopAnnotationView.h
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-9.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "Shop.h"

@interface BaiduShopAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, strong) Shop *shop;

- (id)initWithShopInfo:(Shop *)shop;
- (id)initWithLatitude:(double)lat andLongitude:(double)lon;
@end
