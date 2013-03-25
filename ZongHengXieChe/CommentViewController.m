//
//  CommentViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
{
    IBOutlet    UIWebView       *_myWebView;
}

@end

@implementation CommentViewController

- (void)dealloc
{
    [self.url release];
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
    [self initUI];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [_myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- webview delegate
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
    self.title = @"评论";
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
