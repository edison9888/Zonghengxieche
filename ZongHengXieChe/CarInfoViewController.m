//
//  CarInfoViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CarInfoViewController.h"
#import "CoreService.h"
#import "CarInfo.h"


@interface CarInfoViewController ()
{
    IBOutlet UITableView *_carTableView;
    NSMutableArray *_sectionTitleArray;
    NSMutableArray *_classifiedInfoArray;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CarInfoViewController

- (void)dealloc
{
    [_sectionTitleArray release];
    [_classifiedInfoArray release];
    [_carTableView release];
    [self.dataArray release];
    
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
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- tableview datasource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    DLog(@"[self.dataArray count] = %d",[self.dataArray count]);
    return [[_classifiedInfoArray objectAtIndex:section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"CAR_TYPE_INDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    switch (self.carInfo) {
        case BRAND:
            [cell.textLabel setText:[[[_classifiedInfoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] brand_name]];
            break;
        case SERIES:
            [cell.textLabel setText:[[[_classifiedInfoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] series_name]];
            break;
        case MODEL:
            [cell.textLabel setText:[[[_classifiedInfoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] model_name]];
            break;
            
        default:
            break;
    }
    
    return  cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionTitleArray;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_sectionTitleArray indexOfObject:title];

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitleArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfo *carInfo = [[_classifiedInfoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CarInfoViewController *vc = [[[CarInfoViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    switch (self.carInfo) {
        case BRAND:
        {
            vc.carInfo = SERIES;
            vc.detailID = carInfo.brand_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SERIES:
        {
            vc.carInfo = MODEL;
            vc.detailID = carInfo.series_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MODEL:
        {
            
        }
            break;
            
        default:
            break;
    }

}
#pragma mark- my methods
- (void)initUI
{
    switch (self.carInfo) {
        case BRAND:
            self.titleString = @"选择品牌";
            break;
        case SERIES:
            self.titleString = @"选择系列";
            break;
        case MODEL:
            self.titleString = @"选择车型";
            break;
        default:
            break;
    }
    [self setTitle:self.titleString];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
}

- (void)prepareData
{
    _sectionTitleArray = [[NSMutableArray alloc] init];
    _classifiedInfoArray = [[NSMutableArray alloc] init];
    
    [[CoreService sharedCoreService] loadHttpURL:[self getURL]
                                      withParams:nil
                             withCompletionBlock:^(id data) {
                                 NSArray *dataArray = [[NSArray alloc] initWithArray:[[CoreService sharedCoreService] convertXml2Obj:data withClass:[CarInfo class]]];
                                 for (CarInfo *info in dataArray) {
                                     if (info.word) {
                                         if (![_sectionTitleArray containsObject:info.word]) {
                                             [_sectionTitleArray addObject:info.word];
                                             NSMutableArray *array = [[NSMutableArray alloc] init];
                                             [_classifiedInfoArray addObject:array];
                                             [array release];
                                         }        
                                         NSInteger index = [_sectionTitleArray indexOfObject:info.word];
                                         [[_classifiedInfoArray objectAtIndex:index] addObject:info];
                                     }else{
                                         if (![_sectionTitleArray containsObject:@"ALL"]) {
                                             [_sectionTitleArray addObject:@"ALL"];
                                             NSMutableArray *array = [[NSMutableArray alloc] init];
                                             [_classifiedInfoArray addObject:array];
                                             [array release];
                                         }
                                         [[_classifiedInfoArray objectAtIndex:0] addObject:info];
                                     }
                                 }
                                 [dataArray release];
                                 [_carTableView reloadData];
                             } withErrorBlock:nil];

}

- (NSString *)getURL
{
    switch (self.carInfo) {
        case BRAND:
        {
            return @"http://www.xieche.net/index.php//appandroid/get_allbrands";
        }
            break;
        case SERIES:
        {
            return [NSString stringWithFormat: @"http://www.xieche.net/index.php/appandroid/get_carseries?brand_id=%@", self.detailID];
        }
            break;
        case MODEL:
        {
            return [NSString stringWithFormat: @"http://www.xieche.net/index.php/appandroid/get_carmodel?series_id=%@", self.detailID];
        }
            break;
            
        default:
            break;
    }
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
