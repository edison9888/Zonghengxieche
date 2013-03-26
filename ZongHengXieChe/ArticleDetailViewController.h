//
//  ArticleDetailViewController.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Article.h"
@interface ArticleDetailViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) NSString *article_id;
@end
