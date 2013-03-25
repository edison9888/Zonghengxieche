//
//  MyOrderingViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

enum ORDERING_TYPE {
    ORDERING_TYPE_ALL = 999,
    ORDERING_TYPE_NORMAL = 0,
    ORDERING_TYPE_TUAN = 1
};

enum ORDERING_STATUS {
    ORDERING_STATUS_ALL = 999,
    ORDERING_STATUS_WAITING = 0,
    ORDERING_STATUS_CONFIRM = 1,
    ORDERING_STATUS_FINISHED = 2,
    ORDERING_STATUS_CANCEL = -1
};


@interface MyOrderingViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

- (IBAction)btnPressed:(UIButton *)sender;
- (IBAction)hideOrderingSearchMenu;
- (IBAction)typeBtnSelected:(UIButton *)btn;
- (IBAction)statusBtnSelected:(UIButton *)btn;
@end
