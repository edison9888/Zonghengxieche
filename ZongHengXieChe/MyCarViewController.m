//
//  MyCarViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-13.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "MyCarViewController.h"
#import "CarInfo.h"
#import "CarInfoViewController.h"
#import "CarDetailsViewController.h"
#import "BaseTableViewCell.h"
#import "CouponViewController.h"
#import "LoginViewController.h"
#import "UpKeepViewController.h"
@interface MyCarViewController ()
{
    IBOutlet    UITableView     *_contentTableView;
}

@property (nonatomic, strong)   NSMutableArray  *carArray;
@end

@implementation MyCarViewController

- (void)dealloc {
    
    [_carArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    [super viewDidUnload];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.carArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MYCAR_CELL_IDENTIFIER";
    CarInfo *car = [self.carArray objectAtIndex:indexPath.row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    [cell.textLabel setText:car.car_name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", car.brand_name, car.series_name, car.model_name]];
    [cell.imageView setImage:[UIImage imageNamed:@"my_cars_icon"]];
    [cell setTitleImageWithUrl:car.brand_logo withSize:CGSizeMake(40, 40)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.carArray removeObjectAtIndex:indexPath.row];
        [_contentTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfo *car = [_carArray objectAtIndex:indexPath.row];
    
    switch (self.entrance) {
        case ENTRANCE_COUPON:
        {
            for (UIViewController *v in self.navigationController.viewControllers) {
                if ([v isKindOfClass:[CouponViewController class]]) {
                    CouponViewController *couponVC = (CouponViewController *)v;
                    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
                    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
                    [dic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.latitude] forKey:@"lat"];
                    [dic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.longitude] forKey:@"long"];
                    [dic setObject:car.model_id forKey:@"model_id"];
                    [dic setObject:car.series_id forKey:@"series_id"];
                    [dic setObject:car.brand_id forKey:@"brand_id"];
                    [couponVC setArgumentsDic:dic];
                    [couponVC getCoupons];
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
                    [shopVC initArguments];
                    [shopVC.argumentsDic setObject:car.model_id forKey:@"model_id"];
                    [shopVC.argumentsDic setObject:car.series_id forKey:@"series_id"];
                    [shopVC.argumentsDic setObject:car.brand_id forKey:@"brand_id"];
                    [shopVC getShops];
                    [self.navigationController popToViewController:v animated:YES];
                }
            }
        }
            break;
            
        default:
        {
            CarDetailsViewController *vc = [[[CarDetailsViewController alloc] init] autorelease];
            [vc fillCarInfo:car];
            [vc setCrudType:UPDATE];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
    
    
    
    
    
}


#pragma mark- custom methods
- (void)prepareData
{
    [self.loadingView setHidden:NO];
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *token = [[[CoreService sharedCoreService] currentUser] token];
    if (!token) {
        [self pushLoginVC];
    }else{
        [dic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
    }
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_mycars"
                                      withParams:dic
                             withCompletionBlock:^(id data) {
                                 DLog(@"%@", (NSString *)data);
                                 [self.loadingView setHidden:YES]; 
                                 if (data) {
                                     self.carArray = [[CoreService sharedCoreService] convertXml2Obj:data withClass:[CarInfo class]];
                                     [_contentTableView reloadData];
                                 }
                                 
                             } withErrorBlock:^(NSError *error) {
                                 [self.loadingView setHidden:YES];
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络出错, 请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                 [alert show];
                                 [alert release];
                             }];

}

- (void)initUI
{
    [self setTitle:@"我的车辆"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(280, 3, 35, 35)];
    [addBtn setImage:[UIImage imageNamed:@"plus_btn"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addMyCar) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:addBtn];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addMyCar
{
    CarDetailsViewController *vc = [[[CarDetailsViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
