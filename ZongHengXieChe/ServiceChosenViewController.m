//
//  ServiceChosenViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ServiceChosenViewController.h"
#import "MyCalendarViewController.h"
#import "OrderingDetailsViewController.h"

@interface ServiceChosenViewController ()
{
    IBOutlet    UIScrollView    *_myScrollView;
    IBOutlet    UIView          *_contentView;
    NSMutableArray              *_buttonTitleStringArray;
    NSMutableArray              *_buttonArray;
}

@end

@implementation ServiceChosenViewController

- (void)dealloc
{
    [_buttonArray release];
    [_buttonTitleStringArray release];
    
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

#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"1/3 服务选择"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    [_myScrollView setContentSize:_contentView.frame.size.height>367?_contentView.frame.size:CGSizeMake(320, 367)];
}

- (void)prepareData
{
    _buttonTitleStringArray = [[NSMutableArray alloc] initWithObjects:@"小保养",@"大保养",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片  ",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片",@"前制动盘片", nil];
    _buttonArray = [[NSMutableArray alloc] init];
    for (NSInteger index=0; index<_buttonTitleStringArray.count; index++) {
        NSInteger x = index%2;
        NSInteger y = index/2;
        UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [serviceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 18)];
        [serviceBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [serviceBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [serviceBtn setFrame:CGRectMake(65+135*x, 55+45*y, 114, 35)];
        [serviceBtn setBackgroundImage:[UIImage imageNamed:@"service_unselected"] forState:UIControlStateNormal];
        [serviceBtn setBackgroundImage:[UIImage imageNamed:@"service_selected"] forState:UIControlStateSelected];
        [serviceBtn setTitle:[_buttonTitleStringArray objectAtIndex:index] forState:UIControlStateNormal];
        [serviceBtn setTitle:[_buttonTitleStringArray objectAtIndex:index] forState:UIControlStateSelected];
        [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [serviceBtn addTarget:self action:@selector(serviceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:serviceBtn];
        [_buttonArray addObject:serviceBtn];
    }

}

- (void)serviceButtonPressed:(UIButton *)serviceButton
{
    [serviceButton setSelected:!serviceButton.selected];
}


- (IBAction)next
{
    MyCalendarViewController *vc = [[[MyCalendarViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)orderDetails
{
    OrderingDetailsViewController *vc = [[[OrderingDetailsViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton: YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
