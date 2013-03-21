//
//  MyCarViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-13.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CoreService.h"
@interface MyCarViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) enum ENTRANCE entrance;

@end
