//
//  CarInfoViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CarInfoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, assign) enum CAR_INFO  carInfo;
@property (nonatomic, strong) NSString  *detailID;
@property (nonatomic, strong) NSString  *titleString;
@end
