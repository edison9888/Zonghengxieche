//
//  MyOrderingViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MyOrderingViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

- (IBAction)btnPressed:(UIButton *)sender;
@end
