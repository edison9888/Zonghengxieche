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
    
}

- (void)fillInfo
{
    [_shopImage setImage:self.shopDetails.logoImage];
    //TODO 特约字样
    [_shopNameLabel setText:self.shopDetails.shop_name];
    [_shopDescribeTextView setText:self.shopDetails.shop_account];
    [_addressLabel setText:self.shopDetails.shop_address];
    [_rateLabel setText:[NSString stringWithFormat:@"好评率:%@%%",self.shopDetails.comment_rate]];
    [_commentCountLabel setText:[NSString stringWithFormat:@"已有%@人评价",self.shopDetails.comment_number]];
    [_commentContentTextView setText:self.shopDetails.comment];
    //TODO 券\团\零件折扣
//    [_quanContentLabel setText:<#(NSString *)#>]
    [_timeSaleTimeLabel setText:[NSString stringWithFormat:@"%@ -- %@", self.shopDetails.begin_time, self.shopDetails.end_time]];
    [_timeSaleContentLabel setText:[NSString stringWithFormat:@"工时费%.1f折", [self.shopDetails.workhours_sale doubleValue]*10]];
    [_timeSaleWeekLabel setText:[self.shopDetails getWeekday]];
    
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
    [vc setMapCenter:CLLocationCoordinate2DMake(self.shopDetails.latitude, self.shopDetails.longitude)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)prepareData
{
    self.shopDetails = [[ShopDetails alloc] init];
    
    [[CoreService sharedCoreService] loadHttpURL:[NSString stringWithFormat:@"http://www.xieche.net/index.php/App/getshop_detail?shop_id=%@",self.shop.shop_id]
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
//    for (GDataXMLElement *element in rootElement.children) {
//        [self ergodic:element withObj:nil withPropertyList:properties];
//    }
    
    return nil;
}

- (id)ergodic:(GDataXMLElement *)rootElement withObj:(id)obj withPropertyList:(NSArray *)properties
{
    NSArray *propertyList = [[NSArray alloc] initWithArray:properties];
    
    for (GDataXMLElement *childElement in rootElement.children) {
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
    ServiceChosenViewController *vc = [[[ServiceChosenViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


@end