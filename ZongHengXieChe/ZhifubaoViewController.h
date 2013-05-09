//
//  ZhifubaoViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-16.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ZhifubaoViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, copy) NSURL   *URL;
@property (nonatomic, assign) enum ENTRANCE entrance;



@end
