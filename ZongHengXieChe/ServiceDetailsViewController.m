//
//  ServiceDetailsViewController.m
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-8.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ServiceDetailsViewController.h"

@interface ServiceDetailsViewController ()
{
    IBOutlet    UIWebView   *_serviceWebView;
}

@end

@implementation ServiceDetailsViewController

- (void)dealloc
{
    [_url release];
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
    if (self.url) {
        [_serviceWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- custom methods
- (void)prepareData
{
    
}

- (void)initUI
{
    [self setTitle:@"预约详情"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
