//
//  CouponPaymentViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-15.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CouponPaymentViewController.h"
#import "CoreService.h"
#import "User.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "ZhifubaoViewController.h"

@interface CouponPaymentViewController ()
{
    IBOutlet    UIScrollView    *_contentScrollView;
    IBOutlet    UILabel         *_nameLabel;
    IBOutlet    UILabel         *_priceLabel;
    IBOutlet    UILabel         *_countNumberLabel;
    IBOutlet    UILabel         *_totalPriceLabel;
    IBOutlet    UITextField     *_mobileFiled;
}

@end

@implementation CouponPaymentViewController

- (void)dealloc
{
    [self.coupon release];
    
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
    [self prepareData];
    [self initUI];
}

- (void)viewWillAppear: (BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [((CustomTabBarController *)[appDelegate tabbarController]) hideTabbar:YES];
}

- (void)viewWillDisappear: (BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [((CustomTabBarController *)[appDelegate tabbarController]) hideTabbar:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_mobileFiled resignFirstResponder];
    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_contentScrollView setContentOffset:CGPointMake(0, 200) animated:YES];
}


#pragma mark- custom methods
- (void)prepareData
{
    
}

- (void)initUI
{
    [self setTitle:@"提交订单"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    [_nameLabel setText:self.coupon.coupon_name];
    [_priceLabel setText:self.coupon.coupon_amount];
    [_countNumberLabel setText:@"1"];
    [self calculating];
    User *user = [[CoreService sharedCoreService] currentUser];
    if (user) {
        [_mobileFiled setText:user.mobile];
    }
    
    [_contentScrollView setContentSize:CGSizeMake(320, 500)];
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)add:(id)sender {
    [_countNumberLabel setText:[NSString stringWithFormat:@"%d",[_countNumberLabel.text integerValue]+1]];
    [self calculating];
}
- (IBAction)reduce:(id)sender {
    [_countNumberLabel setText:[NSString stringWithFormat:@"%d",[_countNumberLabel.text integerValue]-1]];
    [self calculating];
}
- (IBAction)submit:(id)sender {
    [[CoreService sharedCoreService] loginInBackgroundwithCompletionBlock:^(id data) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[[[CoreService sharedCoreService]currentUser] token] forKey:@"tolken"];
        [dic setObject:self.coupon.uid forKey:@"coupon_id"];
        [dic setObject:_mobileFiled.text forKey:@"mobile"];
        [dic setObject:_countNumberLabel.text forKey:@"number"];
        [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/savecoupon"
                                          withParams:dic withCompletionBlock:^(id data) {
                                              NSDictionary *resultDic = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                              NSString *status = [[[resultDic objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                              if ([status isEqualToString:@"0"]) {
                                                  NSString *membercoupon_id = [[[resultDic objectForKey:@"XML"] objectForKey:@"membercoupon_id"] objectForKey:@"text"];
                                                  NSString *urlStr = [NSString stringWithFormat:@"http://c.xieche.net/apppay/alipayto.php?membercoupon_id=%@",membercoupon_id];
                                                  NSURL *URL = [NSURL URLWithString:urlStr];
                                                  if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                                                      ZhifubaoViewController *vc = [[[ZhifubaoViewController alloc] init] autorelease];
                                                      [vc setURL:URL];
                                                      [vc.navigationItem setHidesBackButton:YES];
                                                      [self.navigationController pushViewController:vc animated:YES];
                                                  }
                                               }
                                          } withErrorBlock:nil];
    }];
}

- (void)calculating
{
    [_mobileFiled resignFirstResponder];
    [_totalPriceLabel setText:[NSString stringWithFormat:@"%d",[_countNumberLabel.text integerValue] * [_priceLabel.text integerValue]]];
}

@end
