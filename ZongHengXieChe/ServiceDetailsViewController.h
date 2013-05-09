//
//  ServiceDetailsViewController.h
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-8.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ServiceDetailsViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSURL *url;

@end
