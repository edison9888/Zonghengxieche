//
//  CityViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-10.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CoreService.h"

@interface CityViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UserApiDelegate>

@property (nonatomic, assign) enum  ENTRANCE entrance;


@end
