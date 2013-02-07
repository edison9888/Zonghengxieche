//
//  ShopDetailsViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-7.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Shop.h"
@interface ShopDetailsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Shop *shop;
@end

#import "Shop.h"
@interface TitleCell : UITableViewCell

@property (nonatomic, strong) Shop *shop;

- (void)applyCell:(Shop *)shop;
@end