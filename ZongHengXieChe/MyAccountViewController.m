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
#import "LoginViewController.h"
#import "UpKeepViewController.h"

enum {
    UPKEEP,
    MY_BOOKING,
    COUPON,
    AFTER_SALE
};

#define kCategoryCellIdentifier @"CategoryCellIdentifier"

@interface MyAccountViewController ()
{
    IBOutlet    UIScrollView    *_kvScrollView;
    IBOutlet    UIPageControl   *_kvPageControl;
    IBOutlet    UITableView     *_optionTableView;
}
@property (nonatomic, strong) NSMutableArray *kvImageArray;
@property (nonatomic, strong) NSMutableArray *optionArray;

@end

@implementation MyAccountViewController

- (void)dealloc
{
    [_kvScrollView release];
    [_kvPageControl release];
    [_optionTableView release];
    
    [self.kvImageArray release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self prepareData];
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
            
            break;
        case COUPON:
            
            break;
        case AFTER_SALE:

            break;
        default:
            break;
    }

}

#pragma mark- custom methods

- (void)initUI
{
    [super changeTitleView];
    UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [userBtn setFrame:CGRectMake(290, 10, 30, 30)];
    [userBtn addTarget:self action:@selector(calloutUserView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:userBtn];
}

- (void)calloutUserView
{
    LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (void)prepareData
{
    _kvImageArray = [[NSMutableArray alloc] init];
    _optionArray = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<4; i++) {
        Option *option = [[Option alloc] init];
        [_optionArray addObject:option];
        [option release];
    }
}


@end
