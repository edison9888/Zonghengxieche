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
#import "ZhifubaoViewController.h"
#import "LoginViewController.h"
#import "Shop.h"
#import "ShopDetails.h"

@interface CouponDetailsViewController ()
{
    IBOutlet    UIScrollView    *_contentScrollView;
    IBOutlet    UIView          *_bgImage;
    IBOutlet    UIImageView     *_logoImage;
    IBOutlet    UILabel         *_titleLabel;
    IBOutlet    UILabel         *_addressLabel;
    IBOutlet    UILabel         *_priceLabel;
    IBOutlet    UILabel         *_discountLabel;
    IBOutlet    UIImageView     *_lineImage;
    IBOutlet    UITextView      *_detailDescribeTextView;
    IBOutlet    UIButton        *_functionBtn;
    
    IBOutlet    UIWebView       *_detailsWebView;

}
@property (nonatomic, strong) Coupon *currentCoupon;

@end

@implementation CouponDetailsViewController

- (void)dealloc
{
    [_coupon_type release];
    [_coupon_id release];
    [_currentCoupon release];
    
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

#pragma mark- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = _detailsWebView.frame;
    frame.size.height = 1;
    _detailsWebView.frame = frame;
    CGSize fittingSize = [_detailsWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    _detailsWebView.frame = frame;
    
    [_contentScrollView setContentSize:CGSizeMake(320, _detailsWebView.frame.origin.y + _detailsWebView.frame.size.height)];
    [self initUI];
}
#pragma  mark- custom methods
- (void)initUI
{
    if ([self.coupon_type isEqualToString:@"1"]) {
        [self setTitle:@"现金券"];
    }else if([self.coupon_type isEqualToString:@"2"]){
        [self setTitle:@"团购券"];
    }else{
        [self setTitle:@"优惠券"];
    }
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    [_functionBtn.titleLabel setFrame:CGRectMake(10, 4, 90, 30)];
    [[_bgImage layer]setCornerRadius:12.0];
    
    [self setFunctionBtnTitle];
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
        [params setObject:@"1" forKey:@"ios"];
    }else{
        [params setObject:self.coupon_id forKey:@"coupon_id"];
        [params setObject:@"1" forKey:@"ios"];
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
        Shop *shop = [[[Shop alloc] init] autorelease];
        [shop setLogo:self.currentCoupon.coupon_logo];
        [shop setShop_name:self.currentCoupon.shop_name];
        [shop setShop_address:self.currentCoupon.shop_address];
        [shop setShop_id:self.currentCoupon.shop_id];
        [shop setShop_maps:self.currentCoupon.shop_maps];
        [shop setWorkhours_sale:self.currentCoupon.workhours_sale];
        [shop setLongitude:longitude];
        [shop setLatitude:latitude];
        
        
        NSMutableArray *shopArray = [NSMutableArray  arrayWithObject:shop];
        [vc setShopArray:shopArray];
        [vc setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)buy:(UIButton *)sender {
    
    if (self.entrance == ENTRANCE_MYTUAN || self.entrance == ENTRANCE_MYCASH) {
        if ([self.currentCoupon.state_str isEqualToString:@"未支付"]) {
            User *user = [[CoreService sharedCoreService]currentUser];
            if (!user.token) {
                [self pushLoginVC];
                return;
            }
            NSString *urlStr = [NSString stringWithFormat:@"http://c.xieche.net/apppay/alipayto.php?membercoupon_id=%@",self.coupon_id];
            NSURL *URL = [NSURL URLWithString:urlStr];
            if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                ZhifubaoViewController *vc = [[[ZhifubaoViewController alloc] init] autorelease];
                [vc setURL:URL];
                if ([self.currentCoupon.coupon_type isEqualToString:@"1"]) {
                    [vc setEntrance:ENTRANCE_MYCASH];
                }else{
                    [vc setEntrance:ENTRANCE_MYTUAN];
                }
                [vc.navigationItem setHidesBackButton:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        return;
    }else{
        CouponPaymentViewController *vc = [[[CouponPaymentViewController alloc] init] autorelease];
        if ([self.currentCoupon.coupon_type isEqualToString:@"1"]) {
            [vc setEntrance:ENTRANCE_MYCASH];
        }else{
             [vc setEntrance:ENTRANCE_MYTUAN];
        }
        [vc.navigationItem setHidesBackButton:YES];
        [vc setCoupon:self.currentCoupon];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)setFunctionBtnTitle
{
    if (self.entrance == ENTRANCE_MYTUAN || self.entrance == ENTRANCE_MYCASH) {
        if ([self.currentCoupon.state_str isEqualToString:@"未支付"]) {
            [_functionBtn setTitle:@"支付" forState:UIControlStateNormal];
            [_functionBtn setTitle:@"支付" forState:UIControlStateHighlighted];
        }else{
            [_functionBtn setTitle:self.currentCoupon.state_str forState:UIControlStateNormal];
            [_functionBtn setTitle:self.currentCoupon.state_str forState:UIControlStateHighlighted];
        }
    }else{
        [_functionBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_functionBtn setTitle:@"立即购买" forState:UIControlStateHighlighted];
    }
    
}


- (void)fillInfo
{
    
    if (self.entrance == ENTRANCE_MYTUAN || self.entrance == ENTRANCE_MYCASH) {
        [_priceLabel setHidden:YES];
        [_lineImage setHidden:YES];
        
        [self setFunctionBtnTitle];
        
        if ([self.currentCoupon.is_pay isEqualToString:@"1"]) {
            [_discountLabel setText:[NSString stringWithFormat:@"消费码:%@", self.currentCoupon.coupon_code]];
            [_discountLabel setHidden:NO];
            [_functionBtn setHidden:NO];
        }else{
            
            [_discountLabel setHidden:NO];
        }
    }else{
        [_discountLabel setText:[NSString stringWithFormat:@"¥ %@",self.currentCoupon.cost_price]];
    }
    
    if (self.currentCoupon.coupon_pic) {
        NSString *handledUrlString = [self.currentCoupon.coupon_pic stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        handledUrlString = [handledUrlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/%@",docDir, handledUrlString];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [_logoImage  setImage:image];
        }else{
            [[CoreService sharedCoreService] loadDataWithURL:self.currentCoupon.coupon_pic withParams:nil withCompletionBlock:^(id data) {
                [_logoImage setImage:[UIImage imageWithData:data]];
            } withErrorBlock:nil];
        }
    }
    [_titleLabel setText:self.currentCoupon.shop_name];
    [_addressLabel setText:self.currentCoupon.shop_address];
    [_priceLabel setText:[NSString stringWithFormat:@"¥ %@",self.currentCoupon.coupon_amount]];
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.currentCoupon.coupon_des, @"/ios/1"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [_detailsWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }

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
- (void)pushLoginVC
{
    
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
