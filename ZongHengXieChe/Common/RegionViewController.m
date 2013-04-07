//
//  RegionViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-16.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "RegionViewController.h"
#import "CoreService.h"
#import "UpKeepViewController.h"
#import "CouponViewController.h"

@interface RegionViewController ()
{
    IBOutlet    UITableView     *_contentTableView;
}
@property (nonatomic, strong) NSMutableArray    *regtionArray;
@end

@implementation RegionViewController

- (void)dealloc
{
    [_city release];
    [_regtionArray release];
    
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


#pragma mark- tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_regtionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"REGTION_CELL_INDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    Region *region = [_regtionArray objectAtIndex:indexPath.row];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setText:region.region_name];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Region *region = [_regtionArray objectAtIndex:indexPath.row];

    switch (self.area_for) {
            
        case ENTRANCE_SHOP:
        {
            for (UIViewController *v in self.navigationController.viewControllers) {
                if ([v isKindOfClass:[UpKeepViewController class]]) {
                    UpKeepViewController *shopVC = (UpKeepViewController *)v;
                    [shopVC setRegion:region];
                    [shopVC initArguments];
                    [shopVC.argumentsDic setObject:self.city.uid forKey:@"city_id"];
                    [shopVC.argumentsDic setObject:region.uid forKey:@"area_id"];
                    [shopVC getShops];
                    [self.navigationController popToViewController:v animated:YES];
                }
            }
        }
            break;
        case ENTRANCE_COUPON:
        {
            for (UIViewController *v in self.navigationController.viewControllers) {
                if ([v isKindOfClass:[CouponViewController class]]) {
                    CouponViewController *couponVC = (CouponViewController *)v;
                    [couponVC initArguments];
                    [couponVC.argumentsDic setObject:self.city.uid forKey:@"city_id"];
                    [couponVC.argumentsDic setObject:region.region_name forKey:@"area"];
                    [couponVC.argumentsDic setObject:region.uid forKey:@"area_id"];
                    [couponVC getCoupons];
                    [self.navigationController popToViewController:v animated:YES];
                }
            }
        }
        default:
            break;
    }
    
    
    
}


#pragma mark- custom methods
- (void)initUI
{
    [self setTitle:@"选择区域"];
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
    NSMutableDictionary  *dic = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.city.uid,@"city_id", nil] autorelease];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_regions"
                                      withParams:dic
                             withCompletionBlock:^(id data) {
                                 self.regtionArray = [[CoreService sharedCoreService] convertXml2Obj:data withClass:[Region class]];
                                 [_contentTableView reloadData];
                                 [self.loadingView setHidden:YES];
                             } withErrorBlock:nil];
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
