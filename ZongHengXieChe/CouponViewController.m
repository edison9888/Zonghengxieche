//
//  CouponViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponCell.h"
#import "CouponDetailsViewController.h"
#import "CoreService.h"
#import "Coupon.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "CarInfoViewController.h"
#import "CityViewController.h"
#import "MyCarViewController.h"
#import "LoginViewController.h"

@interface CouponViewController ()
{
    IBOutlet    UIView          *_topToolBar;
    IBOutlet    UILabel         *_noResultsLabel;
    
    IBOutlet    UITableView     *_myTableView;
    IBOutlet    UIButton        *_carTypeBtn;
    IBOutlet    UIButton        *_cityBtn;
    IBOutlet    UIButton        *_distanceBtn;
    
    IBOutlet    UIView          *_searchMenuView;
    IBOutlet    UIImageView     *_searchMenuBackgroundView;
    IBOutlet    UIButton        *_allBtn;
    IBOutlet    UIButton        *_cashBtn;
    IBOutlet    UIButton        *_tuanBtn;
    
    IBOutlet    UIView          *_searCarTypeView;
    IBOutlet    UIButton        *_myCarBtn;
    IBOutlet    UIButton        *_otherCarBtn;
    IBOutlet    UIButton        *_allCarBtn;
    
    IBOutlet    UIView          *_searchCouponTypeView;
    IBOutlet    UIButton        *_allTypeBtn;
    IBOutlet    UIButton        *_unuseTypeBtn;
    IBOutlet    UIButton        *_usedTypeBtn;
    IBOutlet    UIButton        *_expiredTypeBtn;
    IBOutlet    UIButton        *_allKindsBtn;
    IBOutlet    UIButton        *_cashKindBtn;
    IBOutlet    UIButton        *_tuanKindBtn;
    
    IBOutlet    UIButton        *_allRecommedBtn;
    IBOutlet    UIButton        *_forMeRecommedBtn;
    
    IBOutlet    UIButton        *_footCashBtn;
    IBOutlet    UIButton        *_footTuanBtn;
    
    NSMutableArray  *_topBtnArray;
    NSMutableArray  *_couponTypeBtnArray;
    NSMutableArray  *_couponKindsBtnArray;  //我的XX 搜索view中的button
    
    //EGO
    BOOL                        _reloading;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    UIActivityIndicatorView     *_refreshSpinner;
    
    NSInteger       p_count;//总页数
    NSInteger       p;//当前页
}
@property (nonatomic, strong) NSMutableArray *couponArray;

@end

@implementation CouponViewController

- (void)dealloc
{
    [_area release];
    [_modelId release];
    [_argumentsDic release];
    [_couponArray release];
    [_topBtnArray release];
    [_couponKindsBtnArray release];
    [_couponTypeBtnArray release];
    
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
    
//    [self initUI];
}

- (void)viewWillAppear: (BOOL)animated
{
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self prepareData];
    [self initUI];
//    [self getCoupons];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.couponArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"COUPON_CELL_IDENTIFIER";
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[CouponCell class]]) {
                cell = (CouponCell *)aObj;
                
                break;
            }
        }
    }
    if (self.entrance == ENTRANCE_MYTUAN || self.entrance == ENTRANCE_MYCASH) {
        [cell setEntrance:self.entrance];
    }
    [(CouponCell *)cell applyCell:[self.couponArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coupon *coupon = [self.couponArray objectAtIndex:indexPath.row];
    CouponDetailsViewController *vc = [[[CouponDetailsViewController alloc] init] autorelease];
    if (self.entrance == ENTRANCE_MYTUAN || self.entrance == ENTRANCE_MYCASH) {
        [vc setCoupon_id: coupon.membercoupon_id];
        [vc setCoupon_type:coupon.coupon_type];
        [vc setEntrance:self.entrance];
    }else{
        [vc setCoupon_id: coupon.uid];
        [vc setCoupon_type:coupon.coupon_type];
    }
    
    [vc.navigationItem setHidesBackButton:YES];
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
            [self getCoupons];
        }else{
            _myTableView.tableFooterView = nil;
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
    //[self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [self initArguments];
    [self getCoupons];
    _reloading = YES;
}

- (void)doneLoadingData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_myTableView];
}

- (void)reloacateUI{
    [_topToolBar setHidden:YES];
    CGRect frame = _myTableView.frame;
    frame.origin.y = 0;
    if (IS_IPHONE_5) {
        frame.size.height = 455;
    }else{
        frame.size.height = 385;
    }
    
    _myTableView.frame = frame;
    
    frame = _noResultsLabel.frame;
    frame.origin.y = 30;
    _noResultsLabel.frame = frame;
}

#pragma  mark- custom methods
- (void)initUI
{
    switch (self.entrance) {
        case ENTRANCE_MYCASH:
            [self setTitle:@"现金券"];
            [_footTuanBtn setSelected:NO];
            [_footCashBtn setSelected:YES];
            break;
        case ENTRANCE_MYTUAN:
            [self setTitle:@"团购券"];
            [_footCashBtn setSelected:NO];
            [_footTuanBtn setSelected:YES];
            break;
        default:
            [self setTitle:@"优惠券"];
            break;
    }
    
    
    [super changeTitleView];
    
    [[_searchMenuBackgroundView layer]setCornerRadius:15.0];
    
    if (IS_IPHONE_5) {
        CGRect frame = _searchMenuView.frame;
        frame.size.height = 504;
        _searchMenuView.frame = frame;
        
        frame = _searchCouponTypeView.frame;
        frame.size.height = 592;
        _searchCouponTypeView.frame = frame;

        frame = _searCarTypeView.frame;
        frame.size.height = 592;
        _searCarTypeView.frame = frame;
        
        frame = _myTableView.frame;
        frame.size.height = 423;
        _myTableView.frame=frame;
        
    }
    
    
    [self addNavigationBtn];
    [self configToolBar];
    
    [_carTypeBtn setImage:[UIImage imageNamed:@"coupon_btn1"] forState:UIControlStateNormal];
    [_carTypeBtn setImage:[UIImage imageNamed:@"coupon_btn1_hover"] forState:UIControlStateHighlighted];
    [_carTypeBtn setImage:[UIImage imageNamed:@"coupon_btn1_hover"] forState:UIControlStateSelected];
    [_carTypeBtn setSelected:NO];
    [_topBtnArray addObject:_carTypeBtn];
    
    [_cityBtn setImage:[UIImage imageNamed:@"coupon_btn2"] forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"coupon_btn2_hover"] forState:UIControlStateHighlighted];
    [_cityBtn setImage:[UIImage imageNamed:@"coupon_btn2_hover"] forState:UIControlStateSelected];
    [_cityBtn setSelected:NO];
    [_topBtnArray addObject:_cityBtn];
    
    [_distanceBtn setImage:[UIImage imageNamed:@"coupon_btn3"] forState:UIControlStateNormal];
    [_distanceBtn setImage:[UIImage imageNamed:@"coupon_btn3_hover"] forState:UIControlStateHighlighted];
    [_distanceBtn setImage:[UIImage imageNamed:@"coupon_btn3_hover"] forState:UIControlStateSelected];
    [_distanceBtn setSelected:NO];
    [_topBtnArray addObject:_distanceBtn];
    
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateHighlighted];
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateSelected];
    [_allBtn setSelected:YES];
    [_couponTypeBtnArray addObject:_allBtn];
    
    UIImage *image = [UIImage imageNamed:@"2"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    [_cashBtn setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"2-touch"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    [_cashBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    [_cashBtn setBackgroundImage:image forState:UIControlStateSelected];
    [_couponTypeBtnArray addObject:_cashBtn];
    
    image = [UIImage imageNamed:@"4"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    [_tuanBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"4-touch"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    [_tuanBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateHighlighted];
    [_tuanBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateSelected];
    [_couponTypeBtnArray addObject:_tuanBtn];
    
    [_allRecommedBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_allRecommedBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateHighlighted];
    [_allRecommedBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateSelected];
    [_allRecommedBtn setSelected:YES];

    [_forMeRecommedBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [_forMeRecommedBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateHighlighted];
    [_forMeRecommedBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateSelected];
    
    [_footCashBtn setBackgroundImage:[UIImage imageNamed:@"sale_btn_focus"] forState:UIControlStateSelected];
    [_footTuanBtn setBackgroundImage:[UIImage imageNamed:@"sale_btn_focus"] forState:UIControlStateSelected];
    
    
    [_allTypeBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_allTypeBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateHighlighted];
    [_allTypeBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateSelected];
    [_allTypeBtn setSelected:YES];
    [_couponKindsBtnArray addObject:_allTypeBtn];
    
    [_unuseTypeBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_unuseTypeBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_unuseTypeBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_couponKindsBtnArray addObject:_unuseTypeBtn];
    
    [_usedTypeBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_usedTypeBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_usedTypeBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_couponKindsBtnArray addObject:_usedTypeBtn];
    
    [_expiredTypeBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [_expiredTypeBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateHighlighted];
    [_expiredTypeBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateSelected];
    [_couponKindsBtnArray addObject:_expiredTypeBtn];
    
    [_allKindsBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_allKindsBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateHighlighted];
    [_allKindsBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateSelected];
    [_allKindsBtn setSelected:YES];
    [_couponKindsBtnArray addObject:_allKindsBtn];
    
    [_cashKindBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_cashKindBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_cashKindBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_couponKindsBtnArray addObject:_cashKindBtn];
    
    [_tuanKindBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [_tuanKindBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateHighlighted];
    [_tuanKindBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateSelected];
    [_couponKindsBtnArray addObject:_tuanKindBtn];
    
    [self createEGORefreshHeader];
}

- (void)createEGORefreshHeader
{
    if ( !_refreshHeaderView ) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [_myTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void) createTableFooter
{
    _myTableView.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _myTableView.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setBackgroundColor:[UIColor clearColor]];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多"];
    [tableFooterView addSubview:loadMoreText];
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_refreshSpinner setFrame: CGRectMake(190, _myTableView.tableFooterView.frame.size.height/2+10,20,20)];
    [_refreshSpinner setHidesWhenStopped: YES];
    [tableFooterView addSubview:_refreshSpinner];
    [_myTableView setTableFooterView: tableFooterView];
}

- (void)configToolBar
{
    if (self.entrance == ENTRANCE_SHOP_DETAILS_CASH || self.entrance == ENTRANCE_SHOP_DETAILS_TUAN || self.entrance == ENTRANCE_MYCASH || self.entrance == ENTRANCE_MYTUAN) {
        [_topToolBar setHidden:YES];
        [self reloacateUI];
    }else{
        [_topToolBar setHidden:NO];
    }
}

- (void)addNavigationBtn
{
    
    if (self.entrance == ENTRANCE_MYCASH || self.entrance == ENTRANCE_MYTUAN) {
        [self addHomeBtn];        
        [self addSearchBtn];
    }else if(self.entrance ==  ENTRANCE_SHOP_DETAILS_CASH || self.entrance ==  ENTRANCE_SHOP_DETAILS_TUAN){
        [self addBackBtn];
    }else{
        [self addHomeBtn]; 
        [self addSearchBtn];
    }
}

- (void)addBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];

}



- (void)addHomeBtn
{
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 5, 35, 35)];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:homeBtn];
}

- (void)addSearchBtn
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(280, 5, 35, 35)];
    [searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtbPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:searchBtn];
}

- (void)initArguments
{
    p = 1;
    NSString *coupon_type = nil;
    if (self.argumentsDic && [_argumentsDic objectForKey:@"coupon_type"]) {
        coupon_type = [[[NSString alloc] initWithString:[_argumentsDic objectForKey:@"coupon_type"]] autorelease];
    }
    NSString *cityId = nil;
    if (self.argumentsDic && [self.argumentsDic objectForKey:@"city_id"]) {
        cityId  = [[[NSString alloc] initWithString:[self.argumentsDic objectForKey:@"city_id"]] autorelease];
    }
    self.argumentsDic = [[[NSMutableDictionary alloc] init] autorelease];
    if (cityId) {
        [self.argumentsDic setObject:cityId forKey:@"city_id"];
    }
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    
    if (self.entrance == ENTRANCE_MYCASH || self.entrance == ENTRANCE_MYTUAN) {
        User *user = [[CoreService sharedCoreService] currentUser];
        if (user.token) {
            [_argumentsDic setObject:user.token forKey:@"tolken"];
        }
        if (!coupon_type) {
            if (self.entrance == ENTRANCE_MYCASH) {
                [_argumentsDic setObject:@"1" forKey:@"coupon_type"];
            }else{
                [_argumentsDic setObject:@"2" forKey:@"coupon_type"];
            }
        }
    }else{
        if (coupon_type) {
            [_argumentsDic setObject:coupon_type forKey:@"coupon_type"];
        }
    }
    
    if (!coupon_type) {
        if (self.entrance == ENTRANCE_SHOP_DETAILS_CASH) {
            [self setLocationInfo];
            [_argumentsDic setObject:@"1" forKey:@"coupon_type"];
        }else if(self.entrance == ENTRANCE_SHOP_DETAILS_TUAN){
            [self setLocationInfo];
            [_argumentsDic setObject:@"2" forKey:@"coupon_type"];
        }
    }else{
        [_argumentsDic setObject:coupon_type forKey:@"coupon_type"];
    }
    
    [self setLocationInfo];
    
}

- (void)setLocationInfo
{
    CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
    [_argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.latitude] forKey:@"lat"];
    [_argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.longitude] forKey:@"long"];
    [self.argumentsDic setObject:@"distance" forKey:@"order"];
}

- (void)prepareData
{
    _topBtnArray = [[NSMutableArray alloc] init];
    _couponTypeBtnArray = [[NSMutableArray alloc] init];
    _couponKindsBtnArray = [[NSMutableArray alloc] init];
    
    if (self.entrance == 0) {
        [self initArguments];
        [self getCoupons];
    }
}


- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPressed:(UIButton *)btn
{
    for (UIButton *button in _topBtnArray) {
        [button setSelected:NO];
    }
    [btn setSelected:YES];
    
    if (btn == _carTypeBtn) {
        [_searCarTypeView setHidden:NO];
    }
    
    if (btn == _cityBtn) {
        CityViewController *vc = [[[CityViewController alloc] init] autorelease];
        [vc.navigationItem setHidesBackButton:YES];
        [vc setEntrance:ENTRANCE_COUPON];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (btn == _distanceBtn) {
        p =  1;
        [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
        [self.argumentsDic setObject:@"distance" forKey:@"order"];
        
        [self getCoupons];
    }
    
}

- (void)searchBtbPressed
{
    switch (self.entrance) {
        case ENTRANCE_MYCASH:
            [_searchCouponTypeView setHidden:NO];
            break;
        case ENTRANCE_MYTUAN:
            [_searchCouponTypeView setHidden:NO];
            break;
        default:
            [_searchMenuView setHidden:NO];
            break;
    }
}

- (IBAction)hideSearchMenu
{
    [_searchMenuView setHidden:YES];
}

- (IBAction)couponBtnPressed:(UIButton *)btn
{
    for (UIButton *button in _couponTypeBtnArray) {
        [button setSelected:NO];
    }
    [btn setSelected:YES];
}


- (void)getCoupons
{
    [self.loadingView setHidden:NO];
    
    NSString *URLString = @"http://c.xieche.net/index.php/appandroid/get_couponlist";
    if (self.entrance == ENTRANCE_MYCASH || self.entrance == ENTRANCE_MYTUAN) {
        URLString = @"http://c.xieche.net/index.php/appandroid/get_mycoupon";
    }
    [[CoreService sharedCoreService] loadHttpURL:URLString
                                      withParams:self.argumentsDic
                             withCompletionBlock:^(id data) {
                                 NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 if ([status isEqualToString:@"1"]) {
                                     [self pushLoginVC];
                                 }else{
                                     NSDictionary *params = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                     p_count = [[[[params objectForKey:@"XML"] objectForKey:@"p_count"] objectForKey:@"text"] integerValue];
                                     if (p>1 && p <= p_count ) {
                                         [self.couponArray addObjectsFromArray:[self convertXml2Obj:data withClass:[Coupon class]]];
                                     }else{    
                                         self.couponArray = [self convertXml2Obj:data withClass:[Coupon class]];
                                         [_myTableView setContentOffset:CGPointMake(0, 0)];
                                     }
                                     _myTableView.tableFooterView = nil;
                                     if (p<p_count) {
                                         [self createTableFooter];
                                     }
                                     p++;
                                     if (self.couponArray.count==0) {
                                         [_noResultsLabel setHidden: NO];
                                     }else{
                                         [_noResultsLabel setHidden: YES];
                                     }
                                     [_myTableView reloadData];
                                     [self.loadingView setHidden:YES];
                                 }
                                 
                             } withErrorBlock:^(NSError *error) {
                                 [self.loadingView setHidden:YES];
                             }];
}


- (NSMutableArray *)convertXml2Obj:(NSString *)xmlString withClass:(Class)clazz
{
    NSMutableArray *objectArray = [[[NSMutableArray alloc] init] autorelease];
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:1 error:&error];
    GDataXMLElement *rootElement = [document rootElement];
    DLog(@"rootElement name = %@ , childrenCount = %d", [rootElement name], [rootElement childCount]);
    
    NSArray *childrenArray = [rootElement children];
    for (NSInteger index = 1; index<childrenArray.count; index++) {
        GDataXMLElement *childElement = [childrenArray objectAtIndex:index];
        id obj = [[clazz alloc] init];
        NSMutableArray *propertyList = [[CoreService sharedCoreService] getPropertyList:clazz];
        if ([childElement elementsForName:@"id"]) {
            id propertyValue = [[[childElement elementsForName:@"id"] objectAtIndex:0]stringValue];
            [obj setValue:propertyValue forKey:@"uid"];
        }
        
        for (NSString *propertyName in propertyList) {
            if ([childElement elementsForName:propertyName]) {
                id propertyValue = [[[childElement elementsForName:propertyName] objectAtIndex:0]stringValue];
                [obj setValue:propertyValue forKey:propertyName];
            }
        }
        [objectArray addObject:obj];
        [obj release];
    }
    return objectArray;
}
- (IBAction)getCouponByType {
    [self initArguments];
    
    for (UIButton *btn in _couponKindsBtnArray) {
        if (btn.selected) {
            [self addArgumetsBySelectedKindsBtnIndex:[_couponKindsBtnArray indexOfObject:btn]];
        }
    }
    [self getCoupons];
    [_searchCouponTypeView setHidden:YES];
}

- (void)addArgumetsBySelectedKindsBtnIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            
            break;
        case 1:
            [self.argumentsDic setObject:@"0" forKey:@"is_use"];
            break;
        case 2:
            [self.argumentsDic setObject:@"1" forKey:@"is_use"];
            break;
        case 3:
            [self.argumentsDic setObject:@"1" forKey:@"is_overtime"];
            break;
        case 4:
            
            break;
        case 5:
            [self.argumentsDic setObject:@"1" forKey:@"coupon_type"];
            break;
        case 6:
            [self.argumentsDic setObject:@"2" forKey:@"coupon_type"];
            break;
        default:
            break;
    }


}

- (IBAction)commendBtnPressed:(UIButton *)sender {
    [_allRecommedBtn setSelected:NO];
    [_forMeRecommedBtn setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)searchCoupons:(UIButton *)sender {
    [_searchMenuView setHidden:YES];
    [self initArguments];
    if (_cashBtn.selected) {
        [self.argumentsDic setObject:@"1" forKey:@"coupon_type"];
    }else if(_tuanBtn.selected){
        [self.argumentsDic setObject:@"2" forKey:@"coupon_type"];
    }
    
    if (_forMeRecommedBtn.selected) {
        if ([[[CoreService sharedCoreService] currentUser] token]) {
            [self initArguments];
            [self.argumentsDic setObject:@"1" forKey:@"recommed"];
            [self.argumentsDic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
            [self getCoupons];
        }else{
            [self pushLoginVC];
        }
        
    }else{
        [self getCoupons];
       
    }
     [_searchMenuView setHidden:YES];
}


- (IBAction)footBtnsPressed:(UIButton *)sender {
    [_footCashBtn setSelected:NO];
    [_footTuanBtn setSelected:NO];

    [sender setSelected:YES];

    [self initArguments];
    if (sender == _footCashBtn) {
        [self.argumentsDic setObject:@"1" forKey:@"coupon_type"];
    }else{
        [self.argumentsDic setObject:@"2" forKey:@"coupon_type"];
    }
    [self getCoupons];
    
    if (self.entrance == ENTRANCE_MYCASH || self.entrance == ENTRANCE_MYTUAN) {
        if (_footCashBtn.selected) {
            [self setTitle:@"现金券"];
        }else{
            [self setTitle:@"团购券"];
        }
        [super changeTitleView];
        [self addNavigationBtn];
    }
}

- (IBAction)hideCarTypeMenu:(UIButton *)sender {
    [_searCarTypeView setHidden:YES];
}

- (IBAction)carTypeSearch:(UIButton *)btn{
    [self hideCarTypeMenu:nil];
    if (btn==_myCarBtn) {
        MyCarViewController *vc = [[[MyCarViewController alloc] init] autorelease];
        [vc.navigationItem setHidesBackButton:YES];
        [vc setEntrance:ENTRANCE_COUPON];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn == _otherCarBtn) {
        CarInfoViewController *vc = [[[CarInfoViewController alloc] init] autorelease];
        [vc.navigationItem setHidesBackButton:YES];
        [vc setEntrance:CAR_FOR_COUPON];
        [vc setCarInfo:BRAND];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn == _allCarBtn) {
        self.argumentsDic = [[[NSMutableDictionary alloc] init] autorelease];
        CLLocation *myCurrentLocation = [[CoreService sharedCoreService] getMyCurrentLocation];
        [_argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.latitude] forKey:@"lat"];
        [_argumentsDic setObject:[NSString stringWithFormat:@"%f",myCurrentLocation.coordinate.longitude] forKey:@"long"];
        [self getCoupons];
    }
}

- (IBAction)btnsOfCouponKindMenuPressed:(UIButton *)btn
{
    NSInteger index = [_couponKindsBtnArray indexOfObject:btn];
    NSInteger min;
    NSInteger max;
    if (index < 4) {
        min = 0;
        max = 4;
    }else{
        min = 4;
        max = 7;
    }
    for (NSInteger i = min; i < max; i++) {
        UIButton *button = [_couponKindsBtnArray objectAtIndex:i];
        [button setSelected:NO];
    }
    [btn setSelected:YES];
}

- (IBAction)hideSearchMenuView
{
    [_searCarTypeView setHidden:YES];
    [_searchMenuView setHidden:YES];
    [_searchCouponTypeView setHidden:YES];
}

- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
