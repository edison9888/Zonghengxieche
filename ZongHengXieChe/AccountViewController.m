//
//  AccountViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-11.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "AccountViewController.h"
#import "MyAccountViewController.h"
#import "UserInfoModifyViewController.h"
#import "PasswordModifyViewController.h"
#import "CoreService.h"
#import "LoginViewController.h"
#import "PointsViewController.h"
#import "MyCarViewController.h"
#import "CouponViewController.h"
enum {
    USER_INFO = 0,
    PASSWORD_CHANGE
};
enum {
    MY_CAR = 0,
    MY_ORDERING
};
enum {
    CASH = 0,
    TUAN
};
enum {
    POINTS = 0
};

@interface AccountViewController ()
{
    IBOutlet    UITableView *_tableview;
    
    NSMutableArray  *_sectionTitleArray;
    NSMutableArray  *_sectionImageArray;
}

@end

@implementation AccountViewController
- (void)dealloc
{
    [_sectionTitleArray release];
    [_sectionImageArray release];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_sectionTitleArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ACCOUNT_CELL_IDENTIFIER";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    [cell.textLabel setText:[[_sectionTitleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [cell.imageView setImage:[[_sectionImageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case USER_INFO:
                    {
                        UserInfoModifyViewController *vc = [[[UserInfoModifyViewController alloc] init] autorelease];
                        [vc.navigationItem setHidesBackButton:YES];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case PASSWORD_CHANGE:
                    {
                        PasswordModifyViewController *vc = [[[PasswordModifyViewController alloc] init] autorelease];
                        [vc.navigationItem setHidesBackButton:YES];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case MY_CAR:
                    {
                        MyCarViewController *vc = [[[MyCarViewController alloc] init] autorelease];
                        [vc.navigationItem setHidesBackButton:YES];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case MY_ORDERING:
                    {
                        PasswordModifyViewController *vc = [[[PasswordModifyViewController alloc] init] autorelease];
                        [vc.navigationItem setHidesBackButton:YES];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
            case 2:
                switch (indexPath.row) {
                    case CASH:
                    {
                        CouponViewController *vc = [[[CouponViewController alloc] init] autorelease];
                        [vc.navigationItem setHidesBackButton:YES];
                        [vc setEntrance:ENTRANCE_MYCASH];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case TUAN:
                    {
                        CouponViewController *vc = [[[CouponViewController alloc] init] autorelease];
                        [vc.navigationItem setHidesBackButton:YES];
                        [vc setEntrance:ENTRANCE_MYTUAN];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
            case 3:
                switch (indexPath.row) {
                    case POINTS:
                    {
                        PointsViewController *vc = [[[PointsViewController alloc] init] autorelease];
                        [vc.navigationItem setHidesBackButton:YES];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
    
    
}

#pragma mark- user delegate
- (void)didLoginBackground:(NSString *)status withMessage:(NSString *)resultMsg
{

}


#pragma mark- custom methods
- (void)initUI
{
    [self setTitle:@"我的携车"];
    [super changeTitleView];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 5, 35, 35)];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:homeBtn];
    
    [_tableview reloadData];
}

- (void)prepareData
{
    [[CoreService sharedCoreService] setDelegate:self];
    _sectionTitleArray = [[NSMutableArray alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"用户信息", @"密码修改", nil] autorelease]
                     ,[[[NSArray alloc] initWithObjects:@"我的车辆", @"我的预约", nil] autorelease]
                     ,[[[NSArray alloc] initWithObjects:@"我的现金券", @"我的团购券", nil] autorelease]
                     ,[[[NSArray alloc] initWithObjects:@"我的积分", nil] autorelease]
                     ,nil];
    
    _sectionImageArray = [[NSMutableArray alloc] initWithObjects:[[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"user_icon2"],[UIImage imageNamed:@"password_icon"], nil] autorelease]
                          ,[[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"my_cars_icon"], [UIImage imageNamed:@"my_order_icon"], nil] autorelease]
                          ,[[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"quan_small_icon"], [UIImage imageNamed:@"tuan_small_icon"], nil] autorelease]
                          ,[[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"my_discount"], nil] autorelease]
                          ,nil];
}

- (void)backToHome
{
    MyAccountViewController *vc = [[[MyAccountViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
