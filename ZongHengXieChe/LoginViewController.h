//
//  LoginViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, assign) enum ENTRANCE entrance;
@property (nonatomic, assign) enum LOGIN_TYPE loginType;
@end
