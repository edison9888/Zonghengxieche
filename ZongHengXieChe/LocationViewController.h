//
//  LocationViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "BMapKit.h"

@interface LocationViewController : BaseViewController<BMKMapViewDelegate>

@property (nonatomic, strong) NSArray *shopArray;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;



@end
