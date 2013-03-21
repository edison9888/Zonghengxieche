//
//  CarDetailsViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-14.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CarInfo.h"
@interface CarDetailsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

- (void)fillCarInfo:(CarInfo *)selectedCar;

@property (nonatomic, assign) enum  CRUD_TYPE crudType;;
@property (nonatomic, assign) enum  ENTRANCE  entrance;
@end
