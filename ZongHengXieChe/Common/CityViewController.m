//
//  CityViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-10.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CityViewController.h"
#import "CoreService.h"
#import "City.h"
#import "RegionViewController.h"
#import "SettingViewController.h"
#import "UpKeepViewController.h"

@interface CityViewController (){
    IBOutlet    UITableView     *_contentTableView;
}

@property (nonatomic, strong) NSMutableArray *cityArray;

@end

@implementation CityViewController
- (void)dealloc
{
    [_cityArray release];
    
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
    [self prepareData];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cityArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"CITY_CELL_INDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    City *city = [_cityArray objectAtIndex:indexPath.row];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setText:city.city_name];
    
    return  cell;
}


- (void)pushToRegtion:(City *)city
{
    RegionViewController *vc = [[[RegionViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [vc setArea_for:self.entrance];
    [vc setCity:city];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     City *city = [_cityArray objectAtIndex:indexPath.row];
    switch (self.entrance) {
        case ENTRANCE_SETTING:
        {
            for (UIViewController *v in self.navigationController.viewControllers) {
                if ([v isKindOfClass:[SettingViewController class]]) {
                    [[CoreService sharedCoreService] setCurrentCity:city.city_name];
                    [self.navigationController popToViewController:v animated:YES];
                }
            }
        }
            break;
            
        case ENTRANCE_SHOP:
        {
            for (UIViewController *v in self.navigationController.viewControllers) {
                if ([v isKindOfClass:[UpKeepViewController class]]) {
                    UpKeepViewController *shopVC = (UpKeepViewController *)v;
                    [shopVC setCity:city];
                    [self pushToRegtion:city];
                }
            }
        }
            break;
            
        default:
        {
            [self pushToRegtion:city];
        }
            break;
    }
}


#pragma mark- custom methods
- (void)initUI
{
    [self setTitle:@"选择城市"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
}


- (void)prepareData
{
    [self.loadingView setHidden:NO];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_citys"
                                      withParams:nil
                             withCompletionBlock:^(id data) {
                                 self.cityArray = [[CoreService sharedCoreService] convertXml2Obj:data withClass:[City class]];
                                 [_contentTableView reloadData];
                                 [self.loadingView setHidden:YES];
                             } withErrorBlock:nil];
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
