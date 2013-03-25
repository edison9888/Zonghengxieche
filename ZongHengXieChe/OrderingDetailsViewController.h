//
//  OrderingDetailsViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Ordering.h"
@interface OrderingDetailsViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) Ordering *ordering;

@end
