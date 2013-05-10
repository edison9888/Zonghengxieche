//
//  SettingViewController.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "SettingViewController.h"
#import "CoreService.h"
#import "MyAccountViewController.h"
#import "CityViewController.h"
#import "CustomTabBarController.h"
#import "AppDelegate.h"


enum  {
    LOCATION = 0,
    CITY = 1
    };

@interface SettingViewController ()
{
    UISwitch    *_gpsSwitch;
    UILabel     *_cityLabel;
    
    NSMutableArray *_sectionArray;
}

@end

@implementation SettingViewController

- (void)dealloc
{
    [_sectionArray release];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [((CustomTabBarController *)[appDelegate tabbarController]) hideTabbar:YES];
    [self refreshCity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SETTING_CELL_IDENTIFIER";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    switch (indexPath.section) {
        case LOCATION:
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:@"打开GPS定位"];
            [cell addSubview:_gpsSwitch];
        }
            break;
        case CITY:
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setText:@"选择所在城市"];
            [cell addSubview:_cityLabel];
        }
            break;
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case LOCATION:
        {
        }
            break;
        case CITY:
        {
            CityViewController *vc = [[[CityViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [vc setEntrance:ENTRANCE_SETTING];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark- custom methods
- (void)initUI
{
    [self setTitle:@"设置"];
    [super changeTitleView];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 5, 35, 35)];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:homeBtn];
    
    _gpsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(222.0f, 8.0f, 100.0f, 40.0f)];
    [_gpsSwitch addTarget:self action:@selector(switched) forControlEvents:UIControlEventValueChanged];
    [_gpsSwitch setOn:[[CoreService sharedCoreService] isGPSValid]];
    
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(210.0f, 5.0f, 70.0f, 30.0f)];
    [_cityLabel setBackgroundColor:[UIColor clearColor]];
    [_cityLabel setTextAlignment:NSTextAlignmentRight];
    [self refreshCity];
}

- (void)refreshCity
{
    [_cityLabel setText:[[[CoreService sharedCoreService] currentSelectedCity] city_name]];
}

- (void)prepareData
{
    _sectionArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 2; index++) {
        switch (index) {
            case LOCATION:
            {
                NSArray *array = [[NSArray alloc] initWithObjects:@"打开GPS定位", nil];
                [_sectionArray addObject:array];
                [array release];
            }
                break;
            case CITY:
            {
                NSArray *array = [[NSArray alloc] initWithObjects:@"选择所在城市", nil];
                [_sectionArray addObject:array];
                [array release];
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (void)backToHome
{
    [((CustomTabBarController *)self.tabBarController) setSelectedTab :-1];
    MyAccountViewController *vc = [[[MyAccountViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)switched
{
    [[CoreService sharedCoreService] setLocationUpdates:_gpsSwitch.isOn];
}

@end
