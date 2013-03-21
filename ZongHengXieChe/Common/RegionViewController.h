//
//  RegionViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-16.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "City.h"
#import "Region.h"

@interface RegionViewController : BaseViewController

@property (nonatomic, assign) enum  ENTRANCE area_for;
@property(nonatomic, strong) City  *city;
@end
