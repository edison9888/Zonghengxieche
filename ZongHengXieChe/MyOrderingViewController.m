//
//  MyOrderingViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "MyOrderingViewController.h"
#import "OrderingCell.h"
#import "OrderingDetailsViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface MyOrderingViewController ()
{
    IBOutlet    UITableView *_myTableView;
    IBOutlet    UIButton    *_unpaidOrderBtn;
    IBOutlet    UIButton    *_allOrderBtn;
    IBOutlet    UIView      *_orderingSearchMenu;
    IBOutlet    UIImageView *_orderingSearchBg;
    
    IBOutlet    UIButton    *_typeAllBtn;
    IBOutlet    UIButton    *_typeCrashBtn;
    IBOutlet    UIButton    *_typeTuanBtn;
    
    IBOutlet    UIButton    *_statusAllBtn;
    IBOutlet    UIButton    *_statusWaitingBtn;
    IBOutlet    UIButton    *_statusConfirmBtn;
    IBOutlet    UIButton    *_statusFinishBtn;
    IBOutlet    UIButton    *_statusCancelBtn;
    
    NSMutableArray          *_typeBtnArray;
    NSMutableArray          *_statusBtnArray;
    
}
@property (nonatomic, strong) NSMutableDictionary *argumentsDic;
@property (nonatomic, strong) NSMutableArray    *orderingArray;
@end

@implementation MyOrderingViewController

- (void)dealloc
{
    [_typeBtnArray release];
    [_statusBtnArray release];
    
    [self.argumentsDic release];
    [self.orderingArray release];
    
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self prepareData];
    [self initUI];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderingArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 147.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ORDERING_CELL_INDENTIFIER";
    
    OrderingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OrderingCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[OrderingCell class]]) {
                cell = (OrderingCell *)aObj;
            }
        }
    }
    [cell applyOrderingCell:[self.orderingArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ordering *ordering = [self.orderingArray objectAtIndex:indexPath.row];
    
    OrderingDetailsViewController *vc = [[[OrderingDetailsViewController alloc] init] autorelease];
    [vc setOrdering:ordering];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"我的预约"];
    [super changeTitleView];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 5, 35, 35)];
    [homeBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:homeBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(280, 5, 35, 35)];
    [searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(showOrderingSearchMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:searchBtn];
    
    [_orderingSearchBg.layer setCornerRadius:15.0f];
    [self initTopBtns];
    
    [self initSearchMenu];
}

- (void)initTopBtns
{
    [_unpaidOrderBtn setImage:[UIImage imageNamed:@"my_order_btn1"] forState:UIControlStateNormal];
    [_unpaidOrderBtn setImage:[UIImage imageNamed:@"my_order_btn1_hover"] forState:UIControlStateSelected];
    
    [_allOrderBtn setImage:[UIImage imageNamed:@"my_order_btn2"] forState:UIControlStateNormal];
    [_allOrderBtn setImage:[UIImage imageNamed:@"my_order_btn2_hover"] forState:UIControlStateSelected];
    [_allOrderBtn setSelected:YES];
}

- (void)initSearchMenu
{
    [_typeAllBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_typeAllBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateHighlighted];
    [_typeAllBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateSelected];
    [_typeAllBtn setTag:ORDERING_TYPE_ALL];
    [_typeAllBtn setSelected:YES];
    [_typeBtnArray addObject:_typeAllBtn];
    
    [_typeCrashBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_typeCrashBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_typeCrashBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_typeCrashBtn setTag:ORDERING_TYPE_NORMAL];
    [_typeBtnArray addObject:_typeCrashBtn];
    
    [_typeTuanBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [_typeTuanBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateHighlighted];
    [_typeTuanBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateSelected];
    [_typeTuanBtn setTag:ORDERING_TYPE_TUAN];
    [_typeBtnArray addObject:_typeTuanBtn];
    
    [_statusAllBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_statusAllBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateHighlighted];
    [_statusAllBtn setBackgroundImage:[UIImage imageNamed:@"1-touch"] forState:UIControlStateSelected];
    [_statusAllBtn setTag:ORDERING_STATUS_ALL];
    [_statusAllBtn setSelected:YES];
    [_statusBtnArray addObject:_statusAllBtn];
    
    [_statusWaitingBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_statusWaitingBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_statusWaitingBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_statusWaitingBtn setTag:ORDERING_STATUS_WAITING];
    [_statusBtnArray addObject:_statusWaitingBtn];
    
    [_statusConfirmBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_statusConfirmBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_statusConfirmBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_statusConfirmBtn setTag:ORDERING_STATUS_CONFIRM];
    [_statusBtnArray addObject:_statusConfirmBtn];
    
    [_statusFinishBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_statusFinishBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateHighlighted];
    [_statusFinishBtn setBackgroundImage:[UIImage imageNamed:@"2-touch"] forState:UIControlStateSelected];
    [_statusFinishBtn setTag:ORDERING_STATUS_FINISHED];
    [_statusBtnArray addObject:_statusFinishBtn];
    
    [_statusCancelBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [_statusCancelBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateHighlighted];
    [_statusCancelBtn setBackgroundImage:[UIImage imageNamed:@"4touch"] forState:UIControlStateSelected];
    [_statusCancelBtn setTag:ORDERING_STATUS_CANCEL];
    [_statusBtnArray addObject:_statusCancelBtn];
}


- (void)prepareData
{
    [self initArguments];
    [self getOrdering];
    [[CoreService sharedCoreService] setDelegate:self];
    _typeBtnArray = [[NSMutableArray alloc] init];
    _statusBtnArray = [[NSMutableArray alloc] init];
}

- (void)getOrdering
{
    [self.loadingView setHidden:NO];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_orders"
                                      withParams:self.argumentsDic
                             withCompletionBlock:^(id data) {
                                 
                                 NSDictionary *result = [[CoreService sharedCoreService]  convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 if ([status isEqualToString:@"1"]) {
                                     [self pushLoginVC];
                                     return;
                                 }else{
                                     [self.loadingView setHidden:YES];
                                     self.orderingArray = [[CoreService sharedCoreService] convertXml2Obj:data withClass:[Ordering class]];
                                     [self.orderingArray removeObjectAtIndex:0];
                                     [_myTableView reloadData];

                                 }
                             } withErrorBlock:^(NSError *error) {
                                 [self.loadingView setHidden:YES];
                             }];
}

- (void)initArguments
{
    self.argumentsDic = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *token = [[[CoreService sharedCoreService] currentUser] token];
    if (token) {
        [self.argumentsDic setObject:token forKey:@"tolken"];
    }
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPressed:(UIButton *)sender {
    [_unpaidOrderBtn setSelected:NO];
    [_allOrderBtn setSelected:NO];
    [sender setSelected:YES];
    
    if (sender == _unpaidOrderBtn) {
        [self initArguments];
        
        [self getOrdering];
    }
}

- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showOrderingSearchMenu
{
    [_orderingSearchMenu setHidden:NO];
}

- (IBAction)hideOrderingSearchMenu
{
    [_orderingSearchMenu setHidden:YES];
}
- (IBAction)doSearchOrdering:(UIButton *)sender {
    [self initArguments];
    for (UIButton *btn in _typeBtnArray) {
        if (btn.selected) {
            switch (btn.tag) {
                case ORDERING_TYPE_ALL:
                    break;
                default:
                    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",btn.tag] forKey:@"order_type"];
                    break;
            }
        }
    }
    
    for (UIButton *btn in _statusBtnArray) {
        if (btn.selected) {
            switch (btn.tag) {
                case ORDERING_STATUS_ALL:
                    break;
                default:
                    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",btn.tag] forKey:@"order_state"];
                    break;
            }
        }
    }
    [self getOrdering];
    [self hideOrderingSearchMenu];
}

- (IBAction)typeBtnSelected:(UIButton *)btn
{
    for (UIButton *btn in _typeBtnArray) {
        [btn setSelected:NO];
    }
    [btn setSelected:YES];
}
- (IBAction)statusBtnSelected:(UIButton *)btn
{
    for (UIButton *btn in _statusBtnArray) {
        [btn setSelected:NO];
    }
    [btn setSelected:YES];
}
- (void)pushLoginVC
{
    
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTokenExpired
{
//    [self.loadingView setHidden:YES];
//    [self pushLoginVC];
}

@end
