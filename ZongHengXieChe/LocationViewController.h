//
//  LocationViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : UIViewController<MKMapViewDelegate>


@property (nonatomic, strong) NSArray *shopArray;

@end
