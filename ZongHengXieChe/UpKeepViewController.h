//
//  UpKeepViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "City.h"
#import "Region.h"
#import "EGORefreshTableHeaderView.h"

@interface UpKeepViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) City *city;
@property (nonatomic, strong) Region *region;
@property (nonatomic, strong) NSMutableDictionary *argumentsDic;

- (void)initArguments;
- (IBAction)carTypeBtnPressed:(id)btn;
- (void)getShops;

@end
