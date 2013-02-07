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

#define KV_SWITCH_INTERVAL      2

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
    NSMutableArray      *_kvImageViewArray;
    NSInteger           _currentPage;
    BOOL                _isKVAnimating;
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

#pragma mark- scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isKVAnimating = NO;
    CGFloat x = scrollView.contentOffset.x;
    DLog(@"%f",x);
    NSInteger pageIndex = x/320;
    [_kvPageControl setCurrentPage:pageIndex];
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
    _currentPage = 0;
    _kvImageViewArray = [[NSMutableArray alloc] init];
    [[CoreService sharedCoreService] loadHttpURL:@"http://www.xieche.net/index.php/appandroid/index_inner"
            withParams:nil
   withCompletionBlock:^(id data) {
       self.kvArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[KeyVision class]];
       [self loadKVImage];
   }withErrorBlock:nil];
    
    if (!self.optionArray) {
        self.optionArray = [[NSMutableArray alloc] init];
    }
    for (NSInteger i=0; i<4; i++) {
        Option *option = [[Option alloc] init];
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
        UIImageView *kvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*index, 0, 320, _kvScrollView.bounds.size.height)];
        [kvImageView setBackgroundColor:[UIColor redColor]];
        [_kvScrollView addSubview:kvImageView];
        [kvImageView release];
        
        KeyVision *kv = [self.kvArray objectAtIndex:index];
        
        DLog(@"%@",kv.pic);
        [[CoreService sharedCoreService] loadDataWithURL:kv.pic
                    withParams:nil
           withCompletionBlock:^(id data) {
               UIImage *image = [UIImage imageWithData:data];
               [kvImageView  setImage:image];
           } withErrorBlock:nil];
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}
@end
