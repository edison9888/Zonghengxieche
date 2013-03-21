//
//  BaseViewController.h
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "LoadingView.h"

enum CAR_INFO {
    BRAND = 1,
    SERIES,
    MODEL
};

enum CAR_INFO_ENTRANCE{
    SELECT_MODEL = 1,
    ADD_MY_CAR,
    CAR_FOR_COUPON,
    CAR_FOR_SHOP
};



enum ENTRANCE{
    ENTRANCE_SHOP = 1,
    ENTRANCE_COUPON,
    ENTRANCE_ORDERING,
    ENTRANCE_SETTING,
    ENTRANCE_MYCASH,
    ENTRANCE_MYTUAN
};


enum CRUD_TYPE{
    ADD = 1,
    DELETE,
    UPDATE,
    QUERY
};

enum COUPON_STATUS_TYPE
{
    IS_USED = 1,
    IS_PAY,
    IS_OVERTME
};

@interface BaseViewController : UIViewController


@property (nonatomic, retain) UIImageView *titleImage;
@property (nonatomic, strong) LoadingView *loadingView;


- (void)changeTitleView;
@end
