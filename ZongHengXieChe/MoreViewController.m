//
//  MoreViewController.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "MoreViewController.h"
#import "AppRecommendViewController.h"
#import "AgreementViewController.h"
#import "ApplicationViewController.h"
#import "MyAccountViewController.h"
#import "CustomTabBarController.h"
#import "AppDelegate.h"

#define APP_ID      588144466
enum  {
    AGREEMENT = 0,
    RECOMMEND,
    RATTING,
    APPLICATION,
    VERSION
};

@interface MoreViewController ()
{
    IBOutlet    UITableView     *_myTableView;
    
    NSMutableArray *_sectionArray;
}

@end

@implementation MoreViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [((CustomTabBarController *)[appDelegate tabbarController]) hideTabbar:YES];
}


#pragma mark- tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];
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
    NSString *identifier = @"MORE_CELL_IDENTIFIER";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    [cell.textLabel setText:[[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:0]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case AGREEMENT:
        {
            AgreementViewController *vc = [[[AgreementViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RECOMMEND:
        {
            AppRecommendViewController *vc = [[[AppRecommendViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RATTING:
        {
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                             APP_ID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case APPLICATION:
        {
            ApplicationViewController *vc = [[[ApplicationViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
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
    [self setTitle:@"更多"];
    [super changeTitleView];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 5, 35, 35)];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:homeBtn];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"当前版本: %@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 250, 220, 50)];
    [versionLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:17]];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setText:version];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [_myTableView addSubview:versionLabel];
    [versionLabel release];
}

- (void)prepareData
{
    _sectionArray = [[NSMutableArray alloc] init];
      
    for (NSInteger index = 0; index < 4; index++) {
        NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
        switch (index) {
            case AGREEMENT:
                [array addObject:@"维修保养预约服务协议"];
                break;
            case RECOMMEND:
                [array addObject:@"应用推荐"];
                break;
            case RATTING:
                [array addObject:@"应用评价"];
                break;
            case APPLICATION:
                [array addObject:@"申请为签约用户"];
                break;
            default:
                break;
        }
        [_sectionArray addObject: array];
    }
}

- (void)backToHome
{
    [((CustomTabBarController *)self.tabBarController) setSelectedTab :-1];
    MyAccountViewController *vc = [[[MyAccountViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:NO];
}



@end
