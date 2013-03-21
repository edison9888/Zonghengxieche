//
//  AgreementViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-11.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
{
    IBOutlet    UIWebView   *_webview;
}

@end

@implementation AgreementViewController

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
    
    NSString *urlString = @"http://c.xieche.net/index.php/appandroid/get_rules";
    NSURLRequest  *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webview loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingView setHidden:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView setHidden:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loadingView setHidden:YES];
}

#pragma mark- custom methods
- (void)initUI
{
    [self setTitle:@"服务协议"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    [self.loadingView setHidden:NO];
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
