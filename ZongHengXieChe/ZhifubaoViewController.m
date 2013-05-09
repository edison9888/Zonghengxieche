//
//  ZhifubaoViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-16.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ZhifubaoViewController.h"
#import "CouponViewController.h"

@interface ZhifubaoViewController ()
{
    IBOutlet    UIWebView   *_contentWebView;
}
@end

@implementation ZhifubaoViewController

- (void)dealloc
{
    [self.URL release];
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
    if ([[UIApplication sharedApplication] canOpenURL:self.URL]) {
        [_contentWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"支付"];
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


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     NSString *url = [[request URL] absoluteString];
    if ([url hasPrefix:@"xieche-uri://"]) {
        for (UIViewController *v in self.navigationController.viewControllers) {
            if ([v isKindOfClass:[CouponViewController class]]) {
                CouponViewController *couponVC = (CouponViewController *)v;
                [couponVC setEntrance:self.entrance];
                [couponVC initArguments];
                [couponVC getCoupons];
                [self.navigationController popToViewController:couponVC animated:YES];
            }
        }
        return NO;
    }
    return YES;
}
@end
