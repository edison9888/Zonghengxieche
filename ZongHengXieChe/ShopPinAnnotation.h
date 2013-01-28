//
//  ShopPinAnnotation.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-27.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Shop.h"

@interface ShopPinAnnotation : NSObject<MKAnnotation>

@property (nonatomic, strong) Shop *shop;

@end
