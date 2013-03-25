//
//  CommentViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CommentViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSURL *url;

@end
