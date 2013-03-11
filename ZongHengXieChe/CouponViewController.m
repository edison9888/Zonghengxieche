//
//  CouponViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"
#import "CouponDetailsViewController.h"



@interface CouponViewController ()
{
    IBOutlet    UITableView     *_myTableView;
    IBOutlet    UIButton        *_carTypeBtn;
    IBOutlet    UIButton        *_distanceBtn;
    
    IBOutlet    UIView          *_searchMenuView;
    IBOutlet    UIButton        *_allBtn;
    IBOutlet    UIButton        *_cashBtn;
    IBOutlet    UIButton        *_tuanBtn;
    
    NSMutableArray  *_topBtnArray;
    NSMutableArray  *_couponTypeBtnArray;
}

@end

@implementation CouponViewController

- (void)dealloc
{
    [_topBtnArray release];
    [_couponTypeBtnArray release];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"COUPON_CELL_IDENTIFIER";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[CouponCell class]]) {
                cell = (CouponCell *)aObj;
                break;
            }
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponDetailsViewController *vc = [[[CouponDetailsViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"优惠券"];
    [super changeTitleView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(280, 5, 35, 35)];
    [searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtbPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:searchBtn];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 5, 35, 35)];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:homeBtn];
    
    [_carTypeBtn setImage:[UIImage imageNamed:@"sale_btn1"] forState:UIControlStateNormal];
    [_carTypeBtn setImage:[UIImage imageNamed:@"sale_btn1_hover"] forState:UIControlStateHighlighted];
    [_carTypeBtn setImage:[UIImage imageNamed:@"sale_btn1_hover"] forState:UIControlStateSelected];
    [_carTypeBtn setSelected:NO];
    [_topBtnArray addObject:_carTypeBtn];
    
    [_distanceBtn setImage:[UIImage imageNamed:@"sale_btn2"] forState:UIControlStateNormal];
    [_distanceBtn setImage:[UIImage imageNamed:@"sale_btn2_hover"] forState:UIControlStateHighlighted];
    [_distanceBtn setImage:[UIImage imageNamed:@"sale_btn2_hover"] forState:UIControlStateSelected];
    [_distanceBtn setSelected:NO];
    [_topBtnArray addObject:_distanceBtn];
    
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateHighlighted];
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateSelected];
    [_allBtn setSelected:YES];
    [_couponTypeBtnArray addObject:_allBtn];
    
    [_cashBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_cashBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_cashBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_couponTypeBtnArray addObject:_cashBtn];
    
    [_tuanBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [_tuanBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateHighlighted];
    [_tuanBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateSelected];
    [_couponTypeBtnArray addObject:_tuanBtn];
}

- (void)prepareData
{
    _topBtnArray = [[NSMutableArray alloc] init];
    _couponTypeBtnArray = [[NSMutableArray alloc] init];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPressed:(UIButton *)btn
{
    for (UIButton *button in _topBtnArray) {
        [button setSelected:NO];
    }
    [btn setSelected:YES];
}

- (void)searchBtbPressed
{
    [_searchMenuView setHidden:NO];
}

- (IBAction)hideSearchMenu
{
    [_searchMenuView setHidden:YES];
}

- (IBAction)couponBtnPressed:(UIButton *)btn
{
    for (UIButton *button in _couponTypeBtnArray) {
        [button setSelected:NO];
    }
    [btn setSelected:YES];
}

@end
