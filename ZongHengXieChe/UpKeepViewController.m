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
    
    NSArray                 *_TopBtnArray;
}
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageCount;

@end

@implementation UpKeepViewController

- (void)dealloc
{
    [self.shopArray release];

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

- (void)viewWillAppear:(BOOL)animated
{
    [_titleBtn.titleLabel setText:[NSString stringWithFormat:@"%@%@",self.city.city_name , self.region.region_name]];
    [_titleBtn setTitle:[NSString stringWithFormat:@"%@%@",self.city.city_name , self.region.region_name] forState:UIControlStateNormal];
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

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shopArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
    [vc setShop:shop];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- custom methods

- (void)initUI
{
    [super changeTitleView];
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
}

- (void)initLocation
{
    if (!self.city) {
        self.city = [[[City alloc] init] autorelease];
        [self.city setCity_name:@"上海市"];
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
    [self initArguments];
    [self getShops];
}

- (void)getShops
{
    [self.loadingView setHidden:NO];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_shops"
                                      withParams:self.argumentsDic
                             withCompletionBlock:^(id data) {
                                 [self.loadingView setHidden:YES];
                                 NSMutableArray *tempArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[Shop class]];
                                 self.shopArray = [NSMutableArray arrayWithArray:[tempArray subarrayWithRange:NSMakeRange(1, tempArray.count-1)]];
                                 [_shopTableView reloadData];
                             }
                                  withErrorBlock:^(NSError *error) {
                                      [self.loadingView setHidden:YES];
                                  }];
}

- (void)initArguments
{
    self.argumentsDic = [[[NSMutableDictionary alloc] init] autorelease];
    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
//    [self.argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.latitude] forKey:@"lat"];
//    [self.argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.longitude] forKey:@"long"];
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"p"];
    
    
    
}

- (void)getShops:(NSMutableDictionary *)params
{
    self.currentPageNumber = 0;
    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
    self.argumentsDic = [[[NSMutableDictionary alloc] init] autorelease];
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.latitude] forKey:@"lat"];
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.longitude] forKey:@"long"];
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",self.currentPageNumber] forKey:@"p"];
    [self.argumentsDic addEntriesFromDictionary:params];
    
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_shops"
                                      withParams:self.argumentsDic
                             withCompletionBlock:^(id data) {
                                 
                                 NSMutableArray *tempArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[Shop class]];
                                 
                                 self.shopArray = [NSMutableArray arrayWithArray:[tempArray subarrayWithRange:NSMakeRange(1, tempArray.count-1)]];
//                                 [self sortShopsByRate];
                                 [_shopTableView reloadData];
                             }
                                  withErrorBlock:^(NSError *error) {
                                  }];
}

- (void)getMoreShops
{
    if (self.currentPageNumber<self.totalPageCount) {
        self.currentPageNumber++;
        [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_shops"
                                          withParams:self.argumentsDic
                                 withCompletionBlock:^(id data) {
                                     NSMutableArray *tempArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[Shop class]];
                                     [self.shopArray addObjectsFromArray:[tempArray subarrayWithRange:NSMakeRange(1, tempArray.count-1)]];
                                     [_shopTableView reloadData];
                                 }
                                      withErrorBlock:^(NSError *error) {
                                      }];
    }

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
    self.shopArray = [self.shopArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Shop *shop1 = (Shop *)obj1;
        Shop *shop2 = (Shop *)obj2;
        
        if ([shop1.comment_rate integerValue] > [shop2.comment_rate integerValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    [_shopTableView reloadData];
}


- (IBAction)sortShopsByDistance
{
    [self initArguments];
    [self getShops];
}

- (IBAction)carTypeBtnPressed:(UIButton *)btn
{
    [_carTypeView setHidden:YES];
    switch (btn.tag) {
        case MY_TYPE:
        {
            MyCarViewController *vc = [[[MyCarViewController alloc] init] autorelease];
            [vc setEntrance:ENTRANCE_SHOP];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
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

@end
