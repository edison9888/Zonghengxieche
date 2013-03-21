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

@interface MyOrderingViewController ()
{
    IBOutlet    UITableView *_myTableView;
    IBOutlet    UIButton    *_unpaidOrderBtn;
    IBOutlet    UIButton    *_allOrderBtn;
}

@end

@implementation MyOrderingViewController

- (void)dealloc
{
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

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ORDERING_CELL_INDENTIFIER";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OrderingCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[OrderingCell class]]) {
                cell = (OrderingCell *)aObj;
            }
        }
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderingDetailsViewController *vc = [[[OrderingDetailsViewController alloc] init] autorelease];
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
    
    [_unpaidOrderBtn setImage:[UIImage imageNamed:@"my_order_btn1"] forState:UIControlStateNormal];
    [_unpaidOrderBtn setImage:[UIImage imageNamed:@"my_order_btn1_hover"] forState:UIControlStateSelected];
    
    [_allOrderBtn setImage:[UIImage imageNamed:@"my_order_btn2"] forState:UIControlStateNormal];
    [_allOrderBtn setImage:[UIImage imageNamed:@"my_order_btn2_hover"] forState:UIControlStateSelected];
    
    [_unpaidOrderBtn setSelected:YES];
}

- (void)prepareData
{
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPressed:(UIButton *)sender {
    [_unpaidOrderBtn setSelected:NO];
    [_allOrderBtn setSelected:NO];
    [sender setSelected:YES];
}

- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
