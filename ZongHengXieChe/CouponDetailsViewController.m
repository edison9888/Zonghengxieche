//
//  CouponDetailsViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CouponDetailsViewController.h"
#import "CoreService.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationViewController.h"
#import "CouponPaymentViewController.h"

@interface CouponDetailsViewController ()
{
    IBOutlet    UIView          *_bgImage;
    IBOutlet    UIImageView     *_logoImage;
    IBOutlet    UILabel         *_titleLabel;
    IBOutlet    UILabel         *_addressLabel;
    IBOutlet    UILabel         *_priceLabel;
    IBOutlet    UILabel         *_discountLabel;
    IBOutlet    UIImageView     *_lineImage;
    IBOutlet    UITextView      *_detailDescribeTextView;
    IBOutlet    UIButton        *_functionBtn;
    IBOutlet    UILabel         *_statusLabel;

}
@property (nonatomic, strong) Coupon *currentCoupon;

@end

@implementation CouponDetailsViewController

- (void)dealloc
{
    [self.coupon_id release];
    [self.currentCoupon release];
    
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


#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"优惠券"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    [[_bgImage layer]setCornerRadius:12.0];
}

- (void)prepareData
{
    [self.loadingView setHidden:NO];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *urlStr = @"http://c.xieche.net/index.php/appandroid/get_coupondetail";
    if (self.entrance == ENTRANCE_MYCASH || self.entrance == ENTRANCE_MYTUAN) {
        urlStr = @"http://c.xieche.net/index.php/appandroid/get_mycoupondetail";
        [params setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
        [params setObject:self.coupon_id forKey:@"membercoupon_id"];
    }else{
        [params setObject:self.coupon_id forKey:@"coupon_id"];
    }
    
    [[CoreService sharedCoreService] loadHttpURL:urlStr
                                      withParams:params
                             withCompletionBlock:^(id data) {
                                 [self.loadingView setHidden:YES];
                                 if (self.entrance == ENTRANCE_MYTUAN || self.entrance == ENTRANCE_MYCASH) {
                                      self.currentCoupon = [[self convertXml2Obj:data withClass:[Coupon class]] objectAtIndex:0];
                                     [self.currentCoupon setUid:self.coupon_id];
                                 }else{
                                     self.currentCoupon = [[[CoreService sharedCoreService] convertXml2Obj:data withClass:[Coupon class]] objectAtIndex:0];
                                 }
                                    
                                    [self fillInfo];
                             } withErrorBlock:^(NSError *error) {
                                 [self.loadingView setHidden:YES];
                             }];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addressBtnPressed:(UIButton *)sender {
    NSArray *stringArray = [self.currentCoupon.shop_maps componentsSeparatedByString:@","];
    if ([stringArray count]>0) {
        double longitude = [[stringArray objectAtIndex:0] doubleValue];
        double latitude = [[stringArray objectAtIndex:1] doubleValue];
        LocationViewController *vc = [[[LocationViewController alloc] init] autorelease];
        [vc.navigationItem setHidesBackButton:YES];
        [vc setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)buy:(UIButton *)sender {
    CouponPaymentViewController *vc = [[[CouponPaymentViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [vc setCoupon:self.currentCoupon];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)fillInfo
{
    if (self.entrance == ENTRANCE_MYTUAN || self.entrance == ENTRANCE_MYCASH) {
        [_priceLabel setHidden:YES];
        [_lineImage setHidden:YES];
        [_statusLabel setText:self.currentCoupon.state_str];
        if ([self.currentCoupon.is_pay isEqualToString:@"1"]) {
            [_discountLabel setText:[NSString stringWithFormat:@"消费码:%@", self.currentCoupon.coupon_code]];
            [_functionBtn setHidden:YES];
        }else{
            [_discountLabel setHidden:YES];
        }
    }
    
    if (self.currentCoupon.coupon_pic) {
        [[CoreService sharedCoreService] loadDataWithURL:self.currentCoupon.coupon_pic withParams:nil withCompletionBlock:^(id data) {
            [_logoImage setImage:[UIImage imageWithData:data]];
        } withErrorBlock:nil];
    }
    [_titleLabel setText:self.currentCoupon.shop_name];
    [_addressLabel setText:self.currentCoupon.shop_address];
    [_priceLabel setText:[NSString stringWithFormat:@"¥%@",self.currentCoupon.coupon_amount]];
    [_discountLabel setText:[NSString stringWithFormat:@"¥%@",self.currentCoupon.cost_price]];
    [_detailDescribeTextView setText:self.currentCoupon.coupon_des];

}


- (NSMutableArray *)convertXml2Obj:(NSString *)xmlString withClass:(Class)clazz
{
    NSMutableArray *objectArray = [[[NSMutableArray alloc] init] autorelease];
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:1 error:&error];
    GDataXMLElement *rootElement = [document rootElement];
    DLog(@"rootElement name = %@ , childrenCount = %d", [rootElement name], [rootElement childCount]);
    

        id obj = [[clazz alloc] init];
        NSMutableArray *propertyList = [[CoreService sharedCoreService] getPropertyList:clazz];
        
        if ([rootElement elementsForName:@"id"] && [propertyList containsObject:@"uid"]) {
            id propertyValue = [[[rootElement elementsForName:@"id"] objectAtIndex:0]stringValue];
            [obj setValue:propertyValue forKey:@"uid"];
        }
        
        for (NSString *propertyName in propertyList) {
            if ([rootElement elementsForName:propertyName]) {
                id propertyValue = [[[rootElement elementsForName:propertyName] objectAtIndex:0]stringValue];
                [obj setValue:propertyValue forKey:propertyName];
            }
        }
        [objectArray addObject:obj];
        [obj release];
    
    return objectArray;
}

@end
