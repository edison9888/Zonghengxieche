//
//  ServiceChosenViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ServiceChosenViewController.h"
#import "CoreService.h"
#import "MyCalendarViewController.h"
#import "OrderingDetailsViewController.h"
#import "Service.h"
#import "ServiceDetailsViewController.h"

@interface ServiceChosenViewController ()
{
    IBOutlet    UIScrollView    *_myScrollView;
    IBOutlet    UIView          *_contentView;
    IBOutlet    UIView          *_tipView;
    IBOutlet    UILabel         *_tipLabel;
    IBOutlet    UIView          *_detailView;
    
    UIButton                    *_selectNoneBtn;
    
    NSMutableArray              *_buttonTitleStringArray;
    NSMutableArray              *_serviceIdsArray;
    NSMutableArray              *_buttonArray;
    
    
}

@property (nonatomic, strong) NSMutableArray  *serviceArray;

@end

@implementation ServiceChosenViewController

- (void)dealloc
{
    [_serviceIdsArray release];
    if (self.serviceArray != nil) {
        [self.serviceArray release];
    }
    [_buttonArray release];
    [_buttonTitleStringArray release];
    
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
    [self setTitle:@"1/3 服务选择"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    if (IS_IPHONE_5) {
        CGRect frame = _tipView.frame;
        frame.origin.y += 88;
        [_tipView setFrame:frame];
        [_myScrollView setContentSize:_contentView.frame.size.height>367?_contentView.frame.size:CGSizeMake(320, 367+88)];
    }else{
        [_myScrollView setContentSize:_contentView.frame.size.height>367?_contentView.frame.size:CGSizeMake(320, 367)];
    }
}

- (void)prepareData
{
    _buttonTitleStringArray = [[NSMutableArray alloc] initWithObjects:@"小保养",@"大保养",@"更换前制动片",@"更换后制动片",@"更换前制动盘片",@"更换后制动盘片",@"更换防冻液",@"更换空调滤清器",@"更换火花塞",@"更换正时皮带",@"更换雨刮",@"更换转向助动液",@"更换制动液",@"更换变速箱油",@"更换蓄电池",@"四轮定位",@"清洗喷油门",@"清洗节气门", nil];
    
    Ordering *myOrdering = [[CoreService sharedCoreService] myOrdering];
    if (myOrdering && myOrdering.model_id && ![myOrdering.model_id isEqualToString:@""]) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init]autorelease];
        [dic setObject:myOrdering.model_id forKey:@"model_id"];
        [dic setObject:myOrdering.timesaleversion_id forKey:@"timesaleversion_id"];
        [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_orderprice/"
                                              withParams:dic
                                     withCompletionBlock:^(id data) {
                                         NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                         if (result) {
                                             NSDictionary *services = [[result objectForKey:@"XML"] objectForKey:@"item"];
                                             if (services) {
                                                 NSMutableArray *tempArray = [[[[CoreService sharedCoreService] convertXml2Obj:data withClass:[Service class]] retain] autorelease];
                                                 
                                                 self.serviceArray = [[[NSMutableArray alloc] init] autorelease];
                                                 [self.serviceArray addObject:[tempArray objectAtIndex:1]];
                                                 [self.serviceArray addObject:[tempArray objectAtIndex:0]];
                                                 for (NSInteger index = 2; index<tempArray.count; index++) {
                                                     [self.serviceArray addObject:[tempArray objectAtIndex:index]];
                                                 }
                                                 [self drawUI];
                                             }else{
                                                 [self serviceLocalInit];
                                             }   
                                         }
                                     } withErrorBlock:nil];
    }else{
        [self serviceLocalInit];
    }

}

- (void)serviceLocalInit
{
    self.serviceArray = [[[NSMutableArray alloc] init] autorelease];
    _serviceIdsArray = [[NSMutableArray alloc] initWithObjects:@"10", @"9", @"11", @"12",@"14",@"15",@"16",@"19",@"20",@"25",@"22",@"23",@"24",@"26",@"27",@"28",@"17",@"18",nil];
    for (NSInteger index = 0; index < _buttonTitleStringArray.count; index++) {
        Service *service = [[Service alloc] init];
        [service setService_id:[_serviceIdsArray objectAtIndex:index]];
        [self.serviceArray addObject:service];
    }
    [self drawUI];
}

- (void)drawUI
{
    _buttonArray = [[NSMutableArray alloc] init];
    
    UIImage *unselectedImage = [UIImage imageNamed:@"service_unselected"];
    unselectedImage = [unselectedImage stretchableImageWithLeftCapWidth:floorf(unselectedImage.size.width/2) topCapHeight:floorf(unselectedImage.size.height/2)];
    UIImage *selectedImage = [UIImage imageNamed:@"service_selected"];
    selectedImage = [selectedImage stretchableImageWithLeftCapWidth:floorf(selectedImage.size.width/2) topCapHeight:floorf(selectedImage.size.height/2)];
    
    for (NSInteger index=0; index<_buttonTitleStringArray.count; index++) {
        NSInteger x = index%2;
        NSInteger y = index/2;
        UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [serviceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 18)];
        [serviceBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [serviceBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [serviceBtn setFrame:CGRectMake(60+130*x, 55+45*y, 120, 35)];
        [serviceBtn setBackgroundImage:unselectedImage forState:UIControlStateNormal];
        [serviceBtn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [serviceBtn setTitle:[_buttonTitleStringArray objectAtIndex:index] forState:UIControlStateNormal];
        [serviceBtn setTitle:[_buttonTitleStringArray objectAtIndex:index] forState:UIControlStateSelected];
        [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [serviceBtn addTarget:self action:@selector(serviceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (![[self.serviceArray objectAtIndex:0] allprice]) {
            [serviceBtn setTag:[[_serviceIdsArray objectAtIndex:index] integerValue]];
        }else{
            [serviceBtn setTag:[[[self.serviceArray objectAtIndex:index] service_id] integerValue]];
        }
        [_contentView addSubview:serviceBtn];
        [_buttonArray addObject:serviceBtn];
    }
    _selectNoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectNoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 18)];
    [_selectNoneBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [_selectNoneBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_selectNoneBtn setFrame:CGRectMake(35, 70+45*_buttonArray.count/2, 250, 35)];
    
    [_selectNoneBtn setBackgroundImage:unselectedImage forState:UIControlStateNormal];
    [_selectNoneBtn setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [_selectNoneBtn setTitle:@"我不知道什么项目,到店检查" forState:UIControlStateNormal];
    [_selectNoneBtn setTitle:@"我不知道什么项目,到店检查" forState:UIControlStateSelected];
    [_selectNoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectNoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_selectNoneBtn addTarget:self action:@selector(selectNoService:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_selectNoneBtn];
    
    [self performSelector:@selector(serviceButtonPressed:) withObject:[_buttonArray objectAtIndex:0] afterDelay:0.2];
}


- (void)selectNoService:(UIButton *)btn
{
    [btn setSelected:YES];
    [_tipLabel setText:@"未选择保养项目"];
    for (UIButton *serviceBtn in _buttonArray) {
        [serviceBtn setSelected:NO];
    }
}

- (void)serviceButtonPressed:(UIButton *)serviceButton
{
    [_selectNoneBtn setSelected:NO];
    [serviceButton setSelected:!serviceButton.selected];
    
    if ([_buttonArray indexOfObject:serviceButton]==0) {
        [[_buttonArray objectAtIndex:1]setSelected:NO];
    }
    if ([_buttonArray indexOfObject:serviceButton]==1) {
        [[_buttonArray objectAtIndex:0]setSelected:NO];
    }
    
    if ([[self.serviceArray objectAtIndex:0] allprice]) {
        double totalCost = 0;
        for (NSInteger index=0; index < _buttonArray.count; index++) {
            UIButton *btn = [_buttonArray objectAtIndex:index];
            if (btn.selected) {
                Service *service = [self.serviceArray objectAtIndex:index];
                totalCost += [service.aftersaveprice doubleValue];
            }
        }
        [_tipLabel setText:[NSString stringWithFormat:@"已选择服务总价为: ¥%.2f",totalCost]];
        [_detailView setHidden:NO];
    }else{
        [_tipLabel setText:@"您尚未选择车型或该车型价格暂时无法提供"];
    }
}


- (IBAction)next
{
    Ordering *ordering = [[CoreService sharedCoreService] myOrdering];
    NSMutableString *selectedServiceIds = [[[NSMutableString alloc] init] autorelease];
    for (NSInteger index = 0; index<_buttonArray.count; index++) {
        UIButton *btn = [_buttonArray objectAtIndex:index];
        if (btn.selected) {
            
            if (_serviceIdsArray&&_serviceIdsArray.count>0) {
                [selectedServiceIds appendString:[_serviceIdsArray objectAtIndex:index]];
            }else{
                [selectedServiceIds appendString:[[self.serviceArray objectAtIndex:index] service_id]];
            }
            [selectedServiceIds appendString:@","];
        }
    }
    [ordering setSelect_services:selectedServiceIds];
    
    MyCalendarViewController *vc = [[[MyCalendarViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)orderDetails
{   
    OrderingDetailsViewController *vc = [[[OrderingDetailsViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton: YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)toDetailsView:(UIButton *)sender {
    Ordering *myOrdering = [[CoreService sharedCoreService] myOrdering];
    NSMutableString *serviceIds = [[[NSMutableString alloc] init] autorelease];
    for (NSInteger index=0; index < _buttonArray.count; index++) {
        UIButton *btn = [_buttonArray objectAtIndex:index];
        if (btn.selected) {
            Service *service = [self.serviceArray objectAtIndex:index];
            [serviceIds appendString:service.service_id];
            [serviceIds appendString:@","];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://c.xieche.net/index.php/appandroid/get_pricedetail?model_id=%@&timesaleversion_id=%@&select_services_str=%@", myOrdering.model_id,myOrdering.timesaleversion_id, serviceIds];
    
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        ServiceDetailsViewController *vc = [[[ServiceDetailsViewController alloc] init] autorelease];
        [vc setUrl:url];
        [vc.navigationItem setHidesBackButton: YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
