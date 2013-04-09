//
//  MyAccountViewController.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "MyAccountViewController.h"
#import "Option.h"
#import "OptionCell.h"
#import "Shop.h"
#import "KeyVision.h"
#import "LoginViewController.h"
#import "UpKeepViewController.h"
#import "CoreService.h"
#import "ArticleViewController.h"
#import "MyOrderingViewController.h"
#import "CouponViewController.h"
#import "CouponDetailsViewController.h"
#import "ShopDetailsViewController.h"
#import "ArticleDetailViewController.h"
#import "CityViewController.h"
#import "UserGuideViewController.h"
#define KV_SWITCH_INTERVAL      2

enum {
    UPKEEP,
    MY_BOOKING,
    COUPON,
    AFTER_SALE
};

enum {
    KV_CASH = 1,
    KV_TUAN,
    KV_SHOP,
    KV_ARTICLE
};

#define kCategoryCellIdentifier @"CategoryCellIdentifier"

@interface MyAccountViewController ()
{
    IBOutlet    UIScrollView    *_kvScrollView;
    IBOutlet    UIPageControl   *_kvPageControl;
    IBOutlet    UITableView     *_optionTableView;
    NSMutableArray              *_kvImageViewArray;
    NSInteger                   _currentPage;
    BOOL                        _isKVAnimating;
}
@property (nonatomic, strong) NSMutableArray *kvArray;
@property (nonatomic, strong) NSMutableArray *optionArray;

@end

@implementation MyAccountViewController

- (void)dealloc
{
    [_kvScrollView release];
    [_kvPageControl release];
    [_optionTableView release];
    
    [self.kvArray release];
    [self.optionArray release];
    
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
    [self initUI];
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    if (![userdefaults objectForKey:IsFirstLaunchKey]) {
////        UserGuideViewController *userGuideVC = [[[UserGuideViewController alloc] init] autorelease];
////        [self presentModalViewController:userGuideVC animated:NO];
//        CityViewController *cityVC = [[[CityViewController alloc] init] autorelease];
//        [cityVC.navigationItem setHidesBackButton:YES];
//        [cityVC setEntrance:ENTRANCE_FIRST_TIME_LAUNCH];
//        [self.navigationController pushViewController:cityVC animated:NO];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self initUI];
    [self prepareData];

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (![userdefaults objectForKey:IsFirstLaunchKey]) {
        UserGuideViewController *userGuideVC = [[[UserGuideViewController alloc] init] autorelease];
        [self presentModalViewController:userGuideVC animated:NO];
        CityViewController *cityVC = [[[CityViewController alloc] init] autorelease];
        [cityVC.navigationItem setHidesBackButton:YES];
        [cityVC setEntrance:ENTRANCE_FIRST_TIME_LAUNCH];
        [self.navigationController pushViewController:cityVC animated:NO];
    }
    
    [userdefaults setObject:@"YES" forKey:IsFirstLaunchKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_optionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellIdentifier];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OptionCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[OptionCell class]]) {
                cell = (OptionCell *)aObj;
            }
        }
        [cell applyCell:[self.optionArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case UPKEEP:
        {
            UpKeepViewController *vc = [[[UpKeepViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MY_BOOKING:
        {
            if (![self isLogin]) {
                LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
                [vc.navigationItem setHidesBackButton:YES];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            MyOrderingViewController *vc = [[[MyOrderingViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case COUPON:
        {
            CouponViewController *vc = [[[CouponViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case AFTER_SALE:
        {
            ArticleViewController *vc = [[[ArticleViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}

#pragma mark- scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isKVAnimating = NO;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger pageIndex = x/320;
    [_kvPageControl setCurrentPage:pageIndex];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[CoreService sharedCoreService] UserLogout];
        [self initUI];
    }
}

#pragma mark- custom methods

- (void)initUI
{
    [super changeTitleView];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, -3, 120, 50)];
    [logo setImage:[UIImage imageNamed:@"logo"]];
    [self.navigationItem.titleView addSubview:logo];
    [logo release];
    
    User *user = [[CoreService sharedCoreService] currentUser];
    if( user && user.uid && ![user.uid isEqualToString:@""] ) {
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutBtn setFrame:CGRectMake(270, 3, 40, 40)];
        [logoutBtn setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem.titleView addSubview:logoutBtn];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 3, 100, 40)];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setFont:[UIFont fontWithName:@"Helvetica-blod" size:15]];
        [nameLabel setTextAlignment:NSTextAlignmentRight];
        [nameLabel setText:user.username];
        [self.navigationItem.titleView addSubview:nameLabel];
    }else{
        UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [userBtn setFrame:CGRectMake(270, 3, 40, 40)];
        [userBtn setImage:[UIImage imageNamed:@"user_icon"] forState:UIControlStateNormal];
        [userBtn addTarget:self action:@selector(calloutUserView) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem.titleView addSubview:userBtn];
    }
    
}

- (void)logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"您是否确定要注销当前用户?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
}


- (void)calloutUserView
{
    LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
    [loginVC.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (void)prepareData
{
    _currentPage = 0;
    _kvImageViewArray = [[NSMutableArray alloc] init];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/index_inner"
            withParams:nil
   withCompletionBlock:^(id data) {
       self.kvArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[KeyVision class]];
       [self loadKVImage];
   }withErrorBlock:nil];
    
    if (!self.optionArray) {
        self.optionArray = [[NSMutableArray alloc] init];
    }
    [self.optionArray removeAllObjects];
    for (NSInteger i=0; i<4; i++) {
        Option *option = [[Option alloc] init];
        [option setIcon:[UIImage imageNamed:[NSString stringWithFormat:@"category_%d", i+1]]];
        switch (i) {
            case UPKEEP:
            {
                [option setTitle:@"预约维修保养"];
                [option setDetails:@"查询4S店最低预约折扣, 预约进店并享有预约专享工位."];
            }
                break;
            case MY_BOOKING:
            {
                [option setTitle:@"我的预约"];
                [option setDetails:@"管理预约订单及服务点评, 售后维修记录一目了然."];
            }
                break;
            case COUPON:
            {
                [option setTitle:@"优惠券"];
                [option setDetails:@"预约折扣还不够给力? 看看有没有折扣给力的优惠券."];
            }
                break;   
            case AFTER_SALE:
            {
                [option setTitle:@"售后资讯"];
                [option setDetails:@"精选售后咨询及用车知识, 信息可筛选至您的爱车."];
            }
                break;    
            default:
                break;
        }
        [_optionArray addObject:option];
        [option release];
    }
}

- (void)loadKVImage
{
    [_kvScrollView setContentSize:CGSizeMake(320*[self.kvArray count], _kvScrollView.bounds.size.height)];
    [self setKVAutoSwitch];
    [_kvPageControl setNumberOfPages:[self.kvArray count]];
    for (NSInteger index = 0; index < [self.kvArray count]; index++) {
        KeyVision *kv = [self.kvArray objectAtIndex:index];
        UIImageView *kvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*index, 0, 320, _kvScrollView.bounds.size.height)];
        [kvImageView setUserInteractionEnabled:YES];
        [kvImageView setTag:index];
        [kvImageView setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleKVTapped:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [kvImageView addGestureRecognizer:singleTap];
        [singleTap release];
        [_kvScrollView addSubview:kvImageView];
        [kvImageView release];
        
        [[CoreService sharedCoreService] loadDataWithURL:kv.pic
                    withParams:nil
           withCompletionBlock:^(id data) {
               UIImage *image = [UIImage imageWithData:data];
               [kvImageView  setImage:image];
           } withErrorBlock:nil];
    }
}

- (void)handleKVTapped:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *kvImageView = (UIImageView *)tapGesture.view;
    KeyVision *kv = [self.kvArray objectAtIndex:kvImageView.tag];
    switch ([kv.type integerValue]) {
        case KV_CASH:
        {
            CouponDetailsViewController *vc = [[[CouponDetailsViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [vc setCoupon_id:kv.uid];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case KV_TUAN:
        {
            CouponDetailsViewController *vc = [[[CouponDetailsViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [vc setCoupon_id:kv.uid];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case KV_SHOP:
        {
            ShopDetailsViewController *vc = [[[ShopDetailsViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [vc setShop_id:kv.uid];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case KV_ARTICLE:
        {
            ArticleDetailViewController *vc = [[[ArticleDetailViewController alloc] init] autorelease];
            [vc.navigationItem setHidesBackButton:YES];
            [vc setArticle_id:kv.uid];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}

- (IBAction)pageControllerValueChanged
{
    _currentPage = [_kvPageControl currentPage];
    [self scrollKV];
}

- (void)switchKV
{
    if (_currentPage < [self.kvArray count]) {
        _currentPage++;
    }else{
        _currentPage = 0;
    }
    [self scrollKV];
}

- (void)scrollKV
{
    CGRect rect = CGRectMake(_currentPage * 320.0f, 0, 320.0f, _kvScrollView.bounds.size.height);
    if (_currentPage == 0) {
        [_kvScrollView scrollRectToVisible:rect animated:NO];
    }else{
        [_kvScrollView scrollRectToVisible:rect animated:YES];
    }
    [_kvPageControl setCurrentPage:_currentPage];
}

- (void)setKVAutoSwitch
{
    [NSTimer scheduledTimerWithTimeInterval:KV_SWITCH_INTERVAL target:self selector:@selector(switchKV) userInfo:nil repeats:YES];
}

- (BOOL)isLogin
{
    NSString *token = [[[CoreService sharedCoreService] currentUser] token];
    return  (token && ![token isEqualToString:@""]);
}

@end
