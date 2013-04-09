//
//  UpKeepViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "UpKeepViewController.h"
#import "LocationViewController.h"
#import "Shop.h"
#import "ShopCell.h"
#import "CoreService.h"
#import "ShopDetailsViewController.h"
#import "CarInfoViewController.h"
#import "CityViewController.h"
#import "MyCarViewController.h"
#import "LoginViewController.h"

enum {
    CAR_TYPE = 0,
    RATE,
    DISTANCE
};
enum {
    MY_TYPE = 1,
    ALL_TYPE,
    SEARCH_ALL
};

@interface UpKeepViewController ()
{
    IBOutlet    UIButton    *_carTypeBtn;
    IBOutlet    UIButton    *_ratingBtn;
    IBOutlet    UIButton    *_distanceBtn;
    IBOutlet    UITableView *_shopTableView;
    IBOutlet    UIView      *_carTypeView;
    IBOutlet    UIButton    *_titleBtn;
    IBOutlet    UIImageView *_searchMenuWhiteBg;
    NSArray                 *_TopBtnArray;
    
    //EGO
    BOOL                        _reloading;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    UIActivityIndicatorView     *_refreshSpinner;
    
    
    NSInteger       p_count;//总页数
    NSInteger       p;//当前页
}
@property (nonatomic, strong) NSMutableArray *shopArray;

@end

@implementation UpKeepViewController

- (void)dealloc
{
    [self.shopArray release];
    [_refreshHeaderView release];
    [_carTypeBtn release];
    [_ratingBtn release];
    [_distanceBtn release];
    [_shopTableView release];
    [_TopBtnArray release];
    
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
    [_titleBtn.titleLabel setText:[NSString stringWithFormat:@"%@%@",self.city.city_name , self.region.region_name]];
    [_titleBtn setTitle:[NSString stringWithFormat:@"%@%@",self.city.city_name , self.region.region_name] forState:UIControlStateNormal];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shopArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSLocalizedString(@"SHOP_CELL_INDENTIFIER", nil)];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ShopCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[ShopCell class]]) {
                cell = (ShopCell *)aObj;
            }
        }
    }
    [cell applyCell:[self.shopArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shop *shop = [self.shopArray objectAtIndex:indexPath.row];
    ShopDetailsViewController *vc = [[[ShopDetailsViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    if ([self.argumentsDic objectForKey:@"model_id"]) {
        [shop setModel_id:[self.argumentsDic objectForKey:@"model_id"]];
    }
    [vc setShop:shop];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ego && UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!_reloading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        if (p<=p_count) {
            [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
            [self getShops];
        }else{
            _shopTableView.tableFooterView = nil;
        }
    }else if (scrollView.contentOffset.y <= - 65.0f){
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadData];
    [self performSelector:@selector(doneLoadingData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading?NO:_reloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

- (void)reloadData
{
    p=1;
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];

    [self getShops];
    _reloading = YES;
}

- (void)doneLoadingData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_shopTableView];
}

#pragma mark- custom methods

- (void)initUI
{
    
    [super changeTitleView];
    
    if (IS_IPHONE_5) {
        CGRect frame = _carTypeView.frame;
        frame.size.height+=88;
        _carTypeView.frame = frame;
    }
    
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setFrame:CGRectMake(280, 5, 35, 35)];
    [locationBtn setImage:[UIImage imageNamed:@"map_btn"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(calloutLocationViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:locationBtn];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 5, 35, 35)];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:homeBtn];
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleBtn setFrame:CGRectMake(50, 0, 220, 50)];
    [_titleBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleBtn.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
    [_titleBtn addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem.titleView addSubview:_titleBtn];
    
    [_carTypeBtn setImage:[UIImage imageNamed:@"choose_car_off"] forState:UIControlStateNormal];
    [_carTypeBtn setImage:[UIImage imageNamed:@"choose_car_on"] forState:UIControlStateHighlighted];
    [_carTypeBtn setImage:[UIImage imageNamed:@"choose_car_on"] forState:UIControlStateSelected];
    [_carTypeBtn setSelected:NO];

    [_ratingBtn setImage:[UIImage imageNamed:@"favourite_off"] forState:UIControlStateNormal];
    [_ratingBtn setImage:[UIImage imageNamed:@"favourite_on"] forState:UIControlStateHighlighted];
    [_ratingBtn setImage:[UIImage imageNamed:@"favourite_on"] forState:UIControlStateSelected];
    [_ratingBtn setSelected:YES];
    
    [_distanceBtn setImage:[UIImage imageNamed:@"distance_off"] forState:UIControlStateNormal];
    [_distanceBtn setImage:[UIImage imageNamed:@"distance_on"] forState:UIControlStateHighlighted];
    [_distanceBtn setImage:[UIImage imageNamed:@"distance_on"] forState:UIControlStateSelected];
    [_distanceBtn setSelected:NO];
    
    [_searchMenuWhiteBg.layer setCornerRadius:12];
    
    [self createEGORefreshHeader];
}

- (void)createEGORefreshHeader
{
    if ( !_refreshHeaderView ) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [_shopTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void) createTableFooter
{
    _shopTableView.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _shopTableView.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setBackgroundColor:[UIColor clearColor]];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多"];
    [tableFooterView addSubview:loadMoreText];
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_refreshSpinner setFrame: CGRectMake(190, _shopTableView.tableFooterView.frame.size.height/2+10,20,20)];
    [_refreshSpinner setHidesWhenStopped: YES];
    [tableFooterView addSubview:_refreshSpinner];
    [_shopTableView setTableFooterView: tableFooterView]; 
}

- (void)initLocation
{
    if (!self.city) {
        self.city = [[CoreService sharedCoreService] currentSelectedCity];
        [self.argumentsDic setObject:self.city.uid forKey:@"city_id"];
    }
    if (!self.region) {
        self.region = [[[Region alloc] init] autorelease];
        [self.region setRegion_name:@"全部城区"];
    }
}

- (void)prepareData
{
    [self initLocation];
    _TopBtnArray = [[NSArray alloc] initWithObjects:_carTypeBtn, _ratingBtn, _distanceBtn, nil];
    
    if (!self.argumentsDic) {
        [self initArguments];
        [self getShops];
    }
    
    
}

- (void)getShops
{
    [self.loadingView setHidden:NO];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_shops"
                                      withParams:self.argumentsDic
                             withCompletionBlock:^(id data) {
                                 NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 if ([status isEqualToString:@"1"]) {
                                     [self pushLoginVC];
                                 }else{
                                     [self.loadingView setHidden:YES];
                                     p_count = [[[[result objectForKey:@"XML"] objectForKey:@"p_count"] objectForKey:@"text"] integerValue];
                                     
                                     NSMutableArray *tempArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[Shop class]];
                                     if (tempArray.count>0) {
                                         [tempArray removeObjectAtIndex:0];
                                     }
                                     
                                     if (p>1 && p <= p_count) {
                                         [self.shopArray addObjectsFromArray:tempArray];
                                     }else{
                                         if (p<p_count) {
                                             [self createTableFooter];
                                         }
                                         self.shopArray = tempArray;
                                     }
                                     p++;
                                     [_shopTableView reloadData];
                                 }
                             }
                                  withErrorBlock:^(NSError *error) {
                                      [self.loadingView setHidden:YES];
                                  }];
}

- (void)initArguments
{
    p = 1;
    NSString *cityId = nil;
    if(self.city.uid){
        cityId  = self.city.uid;
    }else if (self.argumentsDic && [self.argumentsDic objectForKey:@"city_id"]) {
      cityId  = [[[NSString alloc] initWithString:[self.argumentsDic objectForKey:@"city_id"]] autorelease];
    }else{
        cityId = [[[CoreService sharedCoreService] currentSelectedCity] uid];
    }
    self.argumentsDic = [[[NSMutableDictionary alloc] init] autorelease];
    if (cityId) {
        [self.argumentsDic setObject:cityId forKey:@"city_id"];
    }
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.latitude] forKey:@"lat"];
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.longitude] forKey:@"long"];
}

- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calloutLocationViewController
{
    DLog(@"%d", [self.shopArray count]);
    LocationViewController *vc = [[[LocationViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];    
    [vc setShopArray:self.shopArray];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressed:(id)sender
{
    NSInteger index = [_TopBtnArray indexOfObject:sender];
    for (UIButton *btn in _TopBtnArray) {
        [btn setSelected:NO];
    }
    [(UIButton *)sender setSelected:YES];
    
    switch (index) {
        case CAR_TYPE:
            [_carTypeView setHidden:NO];
            break;
        case RATE:
            [self sortShopsByRate];
            break;
        case DISTANCE:
            [self sortShopsByDistance];
            break;
        default:
            break;
    }

}

- (IBAction)sortShopsByRate
{
    p =  1;
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    NSString *orderValue = [self.argumentsDic objectForKey:@"order"];
    if (orderValue) {
        [self.argumentsDic removeObjectForKey:@"order"];
    }
    [self getShops];
}


- (IBAction)sortShopsByDistance
{
    p =  1;
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [self.argumentsDic setObject:@"distance" forKey:@"order"];
    [self getShops];
}

- (IBAction)carTypeBtnPressed:(UIButton *)btn
{
    [_carTypeView setHidden:YES];
    switch (btn.tag) {
        case MY_TYPE:
        {
            NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
            NSDate *lastLoginDate = [userdefaluts objectForKey:LastLoginTimeKey];
            
            if (lastLoginDate && [lastLoginDate timeIntervalSinceNow]<600) {//10分钟
                MyCarViewController *vc = [[[MyCarViewController alloc] init] autorelease];
                [vc setEntrance:ENTRANCE_SHOP];
                [vc.navigationItem setHidesBackButton:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self pushLoginVC];
            }
        }
            break;
        case ALL_TYPE:
        {
            CarInfoViewController *vc = [[[CarInfoViewController alloc] init] autorelease];
            [vc setCarInfo:BRAND];
            [vc setEntrance:CAR_FOR_SHOP];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SEARCH_ALL:
        {
            [self initArguments];
            [self getShops];
        }
        
        default:
            break;
    }
}

- (void)selectLocation
{
    CityViewController *vc = [[[CityViewController alloc] init] autorelease];
    [vc setEntrance:ENTRANCE_SHOP];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)hideCarTypeView
{
    [_carTypeView setHidden:YES];
}

- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
