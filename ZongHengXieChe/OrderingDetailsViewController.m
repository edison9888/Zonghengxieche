//
//  OrderingDetailsViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "OrderingDetailsViewController.h"
#import "CoreService.h"
#import "OrderingCell.h"
#import "OrderingOptionCell.h"
#import "Service.h"
#import "MyOrderingViewController.h"
#import "LocationViewController.h"
#import "Shop.h"

enum ORDERING_CELL {
    ORDERING_CELL = 0,
    ORDERING_LABEL_CELL = 1,
    ORDERING_OPTION_CELL
};


@interface OrderingDetailsViewController ()
{
    IBOutlet    UIWebView       *_myWebView;
    IBOutlet    UIScrollView    *_myScrollView;
    IBOutlet    UIImageView     *_bgImageView;
    IBOutlet    UILabel         *_orderingIdLabel;
    IBOutlet    UILabel         *_createTimeLabel;
    IBOutlet    UILabel         *_shopNameLabel;
    IBOutlet    UILabel         *_timeSaleLabel;
    IBOutlet    UILabel         *_orderingTimeLabel;
    IBOutlet    UILabel         *_orderStatusLabel;
    IBOutlet    UIImageView     *_shopImageView;
    
    IBOutlet    UILabel         *_addressLabel;
    IBOutlet    UITextView      *_serviceItemTextView;
    IBOutlet    UIButton        *_detailsBtn;
    IBOutlet    UILabel         *_totalPriceLabel;
    IBOutlet    UIImageView     *_lineImageView;
    IBOutlet    UIImageView     *_arrowImageView;
    
    NSMutableArray              *_lowerUIArray;
}
@property (nonatomic, strong) Ordering *orderingDetails;
@end

@implementation OrderingDetailsViewController
- (void)dealloc
{
    [_lowerUIArray release];
    [self.ordering release];
    [self.orderingDetails release];
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
    [self setTitle:@"预约详情"];
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
    self.orderingDetails = [[[Ordering alloc] init] autorelease];
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
    [dic setObject:self.ordering.uid forKey:@"order_id"];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_orderdetail"
                                          withParams:dic
                                 withCompletionBlock:^(id data) {
                                     [self.loadingView setHidden:YES];
                                     [self convertXml2OrderingDetails:data];
                                     [self fillInfo];
                                     NSURL *url = [NSURL URLWithString:self.orderingDetails.detail_html];
                                     NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                     [_myWebView loadRequest:request];
                                 } withErrorBlock:^(NSError *error) {
                                     [self.loadingView setHidden:YES];
                                 }];
    _lowerUIArray = [[NSMutableArray alloc] init];
    [_lowerUIArray addObject:_lineImageView];
    [_lowerUIArray addObject:_detailsBtn];
    [_lowerUIArray addObject:_totalPriceLabel];
    [_lowerUIArray addObject:_arrowImageView];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)come2map:(id)sender {
    double longitude = 0.0;
    double latitude = 0.0;
    NSArray *stringArray = [self.orderingDetails.shop_maps componentsSeparatedByString:@","];
    if ([stringArray count]>0) {
        longitude = [[stringArray objectAtIndex:0] doubleValue];
        latitude = [[stringArray objectAtIndex:1] doubleValue];
    }
    
    LocationViewController *vc = [[[LocationViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    Shop *shop = [[[Shop alloc] init] autorelease];
    [shop setLogo:self.orderingDetails.logo];
    [shop setShop_name:self.orderingDetails.shop_name];
    [shop setShop_address:self.orderingDetails.shop_address];
    [shop setShop_id:self.orderingDetails.shop_id];
    [shop setShop_maps:self.orderingDetails.shop_maps];
    [shop setLongitude:longitude];
    [shop setLatitude:latitude];
    
    NSMutableArray *shopArray = [NSMutableArray  arrayWithObject:shop];
    [vc setShopArray:shopArray];
    [vc setCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getOrderingStatusDesc:(NSString *)status
{
    NSString *statusDesc = @"";
    switch ([status integerValue]) {
        case ORDERING_STATUS_WAITING:
            statusDesc = @"预约等待";
            break;
        case ORDERING_STATUS_CONFIRM:
            statusDesc = @"预约确认";
            break;
        case ORDERING_STATUS_FINISHED:
            statusDesc = @"预约完成";
            break;
        case ORDERING_STATUS_CANCEL:
            statusDesc = @"作废";
            break;
        default:
            break;
    }
    return statusDesc;
}

- (void)fillInfo
{
    UIImage *bgimage = [UIImage imageNamed:@"textfiled_bg"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:floorf(bgimage.size.width/2) topCapHeight:floorf(bgimage.size.height/2)];
    [_bgImageView setImage:bgimage];
    
    [_orderingIdLabel setText:self.orderingDetails.uid];
    [_createTimeLabel setText:[self formateDate:self.orderingDetails.create_time]];
    [_shopNameLabel setText:self.orderingDetails.shop_name];
    [_timeSaleLabel setText:[NSString stringWithFormat:@"%.1f折",[self.orderingDetails.workhours_sale doubleValue]]];
    [_orderingTimeLabel setText:[self formateDate:self.orderingDetails.order_time]];
    [_orderStatusLabel setText:[self getOrderingStatusDesc:self.orderingDetails.order_state]];
    [_shopImageView setImage:[UIImage imageNamed:@"loading"]];
    [[CoreService sharedCoreService] loadDataWithURL:self.orderingDetails.logo
                                          withParams:nil
                                 withCompletionBlock:^(id data) {
                                     [_shopImageView setImage:[UIImage imageWithData:data]];
                                 } withErrorBlock:nil];
    [_addressLabel setText:self.orderingDetails.shop_address];
    [self resizeUI];
}

- (void)resizeUI
{
    NSInteger serviceCount = self.orderingDetails.serviceArray.count;
    [_serviceItemTextView setFrame:CGRectMake(114, 164, 161, serviceCount!=0?30+25*(serviceCount-1):30)];
    [_serviceItemTextView setText:[self formateServiceString]];
    for (UIView *v in _lowerUIArray) {
        CGRect frame = v.frame;
        frame.origin.y += (serviceCount!=0?15*(serviceCount-1):0);
        [v setFrame:frame];
    }
    CGRect frame = _bgImageView.frame;
    frame.size.height += (serviceCount!=0?15*(serviceCount-1):0);
    [_bgImageView setFrame:frame];
    
    frame = _myWebView.frame;
    frame.origin.y = _bgImageView.frame.origin.y + _bgImageView.frame.size.height + 10;
    [_myWebView setFrame: frame];
}

- (Ordering *)convertXml2OrderingDetails:(NSString *)xmlString
{
    NSArray *properties = [[CoreService sharedCoreService] getPropertyList:[Ordering class]];
    NSError *error;
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithXMLString:xmlString options:1 error:&error] autorelease];
    GDataXMLElement *rootElement = [document rootElement];
    [self ergodic:rootElement withPropertyList:properties];
    
    return nil;
}

- (id)ergodic:(GDataXMLElement *)rootElement withPropertyList:(NSArray *)properties
{
    NSArray *propertyList = [[NSArray alloc] initWithArray:properties];
    
    for (GDataXMLElement *childElement in rootElement.children) {
        if ([childElement elementsForName:@"id"] && [propertyList containsObject:@"uid"]) {
            id propertyValue = [[[childElement elementsForName:@"id"] objectAtIndex:0]stringValue];
            [self.orderingDetails setValue:propertyValue forKey:@"uid"];
        }
        
        if([childElement.name isEqualToString:@"serviceitem"]){
            Service *service = [[[Service alloc] init] autorelease];
            [service setService_id:[[[childElement elementsForName:@"i"] objectAtIndex:0] stringValue]];
            [service setName:[[[childElement elementsForName:@"name"] objectAtIndex:0] stringValue]];
            [self.orderingDetails.serviceArray addObject:service];
        }
        
        if (childElement.childCount == 1) {
            for (NSString *propertyName in properties) {
                if([childElement.name isEqualToString:propertyName]){
                    id propertyValue = [childElement stringValue];
                    [self.orderingDetails setValue:propertyValue forKey:propertyName];
                }
            }
        }else{
            [self ergodic:childElement withPropertyList:properties];
        }
    }
    [propertyList release];
    return nil;
}

- (NSString *)formateDate:(NSString *)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatedDate = [dateFormatter stringFromDate:date];
    return formatedDate;
}

- (NSString *)formateServiceString
{
    NSMutableString *serviceNames = [[[NSMutableString alloc] init] autorelease];
    for (NSInteger index = 0; index < self.orderingDetails.serviceArray.count; index++) {
        Service *service = [self.orderingDetails.serviceArray objectAtIndex:index];
        [serviceNames appendString:service.name];
        if (self.orderingDetails.serviceArray.count>0 &&index != self.orderingDetails.serviceArray.count-1) {
            [serviceNames appendString:@"\r"];
        }
    }
    return serviceNames;
}
- (IBAction)queryPriceDetails:(UIButton *)sender {
    [_myWebView setHidden:!sender.selected];
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [_arrowImageView setImage:[UIImage imageNamed:@"arrow_down_icon"]];
    }else{
        [_arrowImageView setImage:[UIImage imageNamed:@"arrow_up_icon"]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = _myWebView.frame;
    frame.size.height = 1;
    _myWebView.frame = frame;
    CGSize fittingSize = [_myWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    _myWebView.frame = frame;

    
//    CGRect frame = _myWebView.frame;
//    frame.size.height = _myWebView.scrollView.contentSize.height;
    [_myScrollView setContentSize:CGSizeMake(320, _myWebView.frame.origin.y + _myWebView.frame.size.height)];

}
@end
