//
//  ArticleDetailViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ArticleDetailViewController.h"

@interface ArticleDetailViewController ()
{
    IBOutlet    UIImageView     *_brandImage;
    IBOutlet    UIWebView       *_contentWebView;
}

@end

@implementation ArticleDetailViewController

- (void)dealloc
{
    [_article release];
    [self.article_id release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"售后资讯"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
}

- (void)prepareData
{
    if (self.article) {
        [_brandImage setImage: self.article.brand_logo_image];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://c.xieche.net/index.php/appandroid/article?a_id=%@",self.article?self.article.article_id:self.article_id]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_contentWebView loadRequest:request];
    }
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
