//
//  UpKeepViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "UpKeepViewController.h"
#import "LocationViewController.h"
#import "Shop.h"
@interface UpKeepViewController ()
{
    IBOutlet    UIButton    *_carTypeBtn;
    IBOutlet    UIButton    *_ratingBtn;
    IBOutlet    UIButton    *_distanceBtn;
    IBOutlet    UITableView *_shopTableView;
}
@property (nonatomic, strong) NSMutableArray *shopArray;

@end

@implementation UpKeepViewController

- (void)dealloc
{
    [self.shopArray release];
    [_carTypeBtn release];
    [_ratingBtn release];
    [_distanceBtn release];
    [_shopTableView release];
    
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


#pragma mark- custom methods

- (void)initUI
{
    [super changeTitleView];
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [locationBtn setFrame:CGRectMake(290, 10, 30, 30)];
    [locationBtn addTarget:self action:@selector(calloutLocationViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:locationBtn];
}

- (void)prepareData
{
    [self loadHttpURL:@"http://www.xieche.net/index.php/App/get_shops"
           withParams:nil
  withCompletionBlock:^(id data) {
      self.shopArray = [self convertXml2Obj:(NSString *)data withClass:[Shop class]];
      
  }
       withErrorBlock:^(NSError *error) {
       }];
   
}

- (void)calloutLocationViewController
{
    DLog(@"%d", [self.shopArray count]);
    LocationViewController *vc = [[[LocationViewController alloc] init] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
