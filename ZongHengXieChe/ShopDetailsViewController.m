//
//  ShopDetailsViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-7.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ShopDetailsViewController.h"
#import "Shop.h"
#import "ShopDetails.h"
#import "CoreService.h"
#import "GDataXMLNode.h"
#import "LocationViewController.h"
#import "ServiceChosenViewController.h"
#import "Ordering.h"
#import "TimeSale.h"
#import "TimeSaleView.h"
#import "ProductSaleView.h"
enum {
    TITLE,
    ADDRESS,
    RATE,
    QUAN,
    DISCOUNT,
    BOOKING
};

#define numberOfSections     6
@interface ShopDetailsViewController ()
{
    IBOutlet    UIScrollView    *_contentScrollView;
    IBOutlet    UIView          *_contentView;
    IBOutlet    UIImageView     *_shopImage;
    IBOutlet    UILabel         *_shopNameLabel;
    IBOutlet    UIImageView     *_shopClassImage;
    IBOutlet    UITextView      *_shopDescribeTextView;
    IBOutlet    UILabel         *_addressLabel;
    IBOutlet    UILabel         *_rateLabel;
    IBOutlet    UILabel         *_commentCountLabel;
    IBOutlet    UITextView      *_commentContentTextView;
    IBOutlet    UILabel         *_quanContentLabel;
    IBOutlet    UILabel         *_quanCountLabel;
    IBOutlet    UILabel         *_tuanContentLabel;
    IBOutlet    UILabel         *_tuanCountLabel;
    IBOutlet    UITextView      *_productSaleContentTextView;
    IBOutlet    UILabel         *_timeSaleTimeLabel;
    IBOutlet    UILabel         *_timeSaleContentLabel;
    IBOutlet    UILabel         *_timeSaleWeekLabel;
    IBOutlet    UIButton        *_bookingButton;
    
    CouponBtnView               *_quanCouponView;
    CouponBtnView               *_tuanCouponView;
    ProductSaleView             *_productSaleView;
}

@property (strong, nonatomic) ShopDetails *shopDetails;

@end

@implementation ShopDetailsViewController

- (void) dealloc
{
    [self.shopDetails release];
    [self.shop release];
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
//    [_detailsTableView setSectionFooterHeight:0];
//    [_detailsTableView setSectionHeaderHeight:0];
    [self prepareData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"店铺详情"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    [_contentScrollView setContentSize:CGSizeMake(320, 570)];
    
    [self addGestures];
    
    TimeSaleView *tsv = [[[TimeSaleView alloc] initWithFrame:CGRectMake(0, 50, 320, 50)] autorelease];
    [_contentView addSubview:tsv];
    
    
}

- (void)fillInfo
{
    [_shopImage setImage:self.shopDetails.logoImage];
    [_shopClassImage setHidden:![self.shopDetails.shop_class isEqualToString:@"1"]];
    [_shopNameLabel setText:self.shopDetails.shop_name];
    [_shopDescribeTextView setText:self.shopDetails.shop_account];
    [_addressLabel setText:self.shopDetails.shop_address];
    [_rateLabel setText:[NSString stringWithFormat:@"好评率:%@%%",self.shopDetails.comment_rate]];
    [_commentCountLabel setText:[NSString stringWithFormat:@"已有%@人评价",self.shopDetails.comment_number]];
    [_commentContentTextView setText:self.shopDetails.comment];
    [_quanContentLabel setText:self.shopDetails.coupon1_name];
    [_quanCountLabel setText:self.shopDetails.coupon_count1];
    [_tuanContentLabel setText:self.shopDetails.coupon2_name];
    [_tuanCountLabel setText:self.shopDetails.coupon_count2];
    [_productSaleContentTextView setText:[self.shopDetails.product_sale isEqualToString:@"0.00"]?@"无":[NSString stringWithFormat:@"%f折",[self.shopDetails.product_sale doubleValue]*10]];
    
    
    [_timeSaleTimeLabel setText:[NSString stringWithFormat:@"%@ -- %@", self.shopDetails.begin_time, self.shopDetails.end_time]];
    [_timeSaleContentLabel setText:[NSString stringWithFormat:@"工时费%.1f折", [self.shopDetails.workhours_sale doubleValue]*10]];
    [_timeSaleWeekLabel setText:[self.shopDetails getWeekday]];
    
    
    if (self.shopDetails.coupon1_id && !_quanCouponView) {
        _quanCouponView = [[CouponBtnView alloc] initCouponBtnViewWithFrame:CGRectMake(7, 290, 300, 43) withType:QUAN_TYPE];
        [_quanCouponView setDelegate:self];
        [_quanCouponView setTitle:self.shopDetails.coupon1_name];
        [_quanCouponView setCount:self.shopDetails.coupon_count1];
        [_contentView addSubview:_quanCouponView];
    }
    
    if (self.shopDetails.coupon2_id && !_tuanCouponView) {
        if (self.shopDetails.coupon1_id) {
            _tuanCouponView = [[CouponBtnView alloc] initCouponBtnViewWithFrame:CGRectMake(7, 290, 300, 43) withType:TUAN_TYPE];
        }else{
            _tuanCouponView = [[CouponBtnView alloc] initCouponBtnViewWithFrame:CGRectMake(7, 335, 300, 43) withType:TUAN_TYPE];
        }
        [_tuanCouponView setDelegate:self];
        [_tuanCouponView setTitle:self.shopDetails.coupon2_name];
        [_tuanCouponView setCount:self.shopDetails.coupon_count2];
        [_contentView addSubview:_tuanCouponView];
    }
    
    if (!_productSaleView) {
        _productSaleView = [self getProductSaleView];
        [_productSaleView setContentText:self.shopDetails.product_sale];
        if (!_tuanCouponView) {
            [_productSaleView setFrame:CGRectMake(7, 290, 300, 43)];
        }else{
            CGRect frame = _tuanCouponView.frame;
            frame.origin.y += 30;
            [_productSaleView setFrame:CGRectMake(0, frame.origin.y+frame.size.height+30, 320, 76)];
        }
        [_contentView addSubview:_productSaleView];
    }
    
    for (NSInteger index = 0; index < self.shopDetails.timesaleArray.count; index++) {
        TimeSale *timeSale = [self.shopDetails.timesaleArray objectAtIndex:index];
        TimeSaleView *timeSaleView = [self getTimeSaleView];
        [timeSaleView fillInfo:timeSale];
        CGFloat y = _productSaleView.frame.size.height + _productSaleView.frame.origin.y;
        [timeSaleView setFrame:CGRectMake(0, y+30+50*index, 320, 50)];
        
        [_contentView addSubview:timeSaleView];
        [_contentView setFrame:CGRectMake(0, 0, 320, timeSaleView.frame.origin.y+50)];
    }
    
    [_contentScrollView setContentSize:CGSizeMake(320, _contentView.frame.size.height)];
}


- (TimeSaleView *)getTimeSaleView
{
    TimeSaleView *timeSaleView;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"TimeSaleView" owner:self options:nil];
    for (id aObj in nibArray) {
        if ([aObj isKindOfClass:[TimeSaleView class]]) {
            timeSaleView = (TimeSaleView *)aObj;
            return timeSaleView;
        }
    }
    return nil;
}

- (ProductSaleView *)getProductSaleView
{
    ProductSaleView *productSaleView;
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"TimeSaleView" owner:self options:nil];
    for (id aObj in nibArray) {
        if ([aObj isKindOfClass:[ProductSaleView class]]) {
            productSaleView = (ProductSaleView *)aObj;
            return productSaleView;
        }
    }
    return nil;
}


- (void)addGestures
{
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBtn setFrame:_addressLabel.frame];
    [addressBtn setBackgroundColor:[UIColor clearColor]];
    [addressBtn addTarget:self action:@selector(pushToLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressBtn];

}

- (void)pushToLocation
{
    LocationViewController *vc = [[[LocationViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [vc setCoordinate:CLLocationCoordinate2DMake(self.shopDetails.latitude, self.shopDetails.longitude)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)prepareData
{
    self.shopDetails = [[ShopDetails alloc] init];
    
    [[CoreService sharedCoreService] loadHttpURL:[NSString stringWithFormat:@"http://c.xieche.net/index.php/appandroid/getshop_detail?shop_id=%@",self.shop.shop_id]
                                      withParams:nil
                             withCompletionBlock:^(id data) {

                                 [self convertXml2ShopDetails:data];
                                 if (self.shop.logoImage) {
                                     self.shopDetails.logoImage = self.shop.logoImage;
                                 }else{
                                     [[CoreService sharedCoreService]loadDataWithURL:self.shopDetails.logo
                                                                          withParams:nil withCompletionBlock:^(id data) {
                                                                              self.shopDetails.logoImage = [UIImage imageWithData:data];
                                                                              [_shopImage setImage:self.shopDetails.logoImage];
                                                                          } withErrorBlock:nil];          
                                 }
                                 if (self.shop.latitude  && self.shop.latitude != 0) {
                                     self.shopDetails.latitude = self.shop.latitude;
                                     self.shopDetails.longitude = self.shopDetails.longitude;
                                 }
                                 [self fillInfo];
                             } withErrorBlock:nil];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (ShopDetails *)convertXml2ShopDetails:(NSString *)xmlString
{
//    NSArray *array = [NSArray arrayWithObjects:@"lastcomment", @"timesale", @"timesaleversion", nil];

    NSArray *properties = [[CoreService sharedCoreService] getPropertyList:[ShopDetails class]];
    NSError *error;
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithXMLString:xmlString options:1 error:&error] autorelease];
    GDataXMLElement *rootElement = [document rootElement];
    [self ergodic:rootElement withObj:nil withPropertyList:properties];

    return nil;
}

- (id)ergodic:(GDataXMLElement *)rootElement withObj:(id)obj withPropertyList:(NSArray *)properties
{
    NSArray *propertyList = [[NSArray alloc] initWithArray:properties];
    
    for (GDataXMLElement *childElement in rootElement.children) {
        if([childElement.name isEqualToString:@"timesale"]){
            TimeSale *timesale = [[[TimeSale alloc] init] autorelease];
            [timesale setTimesale_id:[[[childElement elementsForName:@"timesale_id"] objectAtIndex:0] stringValue]];
            [timesale setWeek:[[[childElement elementsForName:@"week"] objectAtIndex:0] stringValue]];
            [timesale setBegin_time:[[[childElement elementsForName:@"begin_time"] objectAtIndex:0] stringValue]];
            [timesale setEnd_time:[[[childElement elementsForName:@"end_time"] objectAtIndex:0] stringValue]];
            [timesale setTimesaleversion_id:[[[[[childElement elementsForName:@"timesaleversion"] objectAtIndex:0] elementsForName:@"timesaleversion_id"] objectAtIndex:0] stringValue]];
            [timesale setWorkhours_sale:[[[[[childElement elementsForName:@"timesaleversion"] objectAtIndex:0] elementsForName:@"workhours_sale"] objectAtIndex:0] stringValue]];
            [timesale setMemo:[[[[[childElement elementsForName:@"timesaleversion"] objectAtIndex:0] elementsForName:@"memo"] objectAtIndex:0] stringValue]];
            [self.shopDetails.timesaleArray addObject:timesale];
        }
        
        if (childElement.childCount == 1) {
            for (NSString *propertyName in properties) {
                if([childElement.name isEqualToString:propertyName]){
                    id propertyValue = [childElement stringValue];
                    [self.shopDetails setValue:propertyValue forKey:propertyName];
                }
            }
        }else{
            
            [self ergodic:childElement withObj:obj withPropertyList:properties];
        }
    }
    
    [propertyList release];
    return obj;
}
- (IBAction)ordering:(id)sender {
    Ordering *ordering = [[[Ordering alloc] init] autorelease];
    [ordering setShop_id:self.shopDetails.shopid];
    [ordering setTimesaleversion_id:self.shopDetails.timesale_id];
    [[CoreService sharedCoreService] setMyOrdering:ordering];
    
    ServiceChosenViewController *vc = [[[ServiceChosenViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didCouponButtonPressed:(UIButton *)button
{
    DLog(@"didCouponButtonPressed");
}

@end