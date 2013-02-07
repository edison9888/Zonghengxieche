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
#import "ShopCell.h"
#import "CoreService.h"
#import "ShopDetailsViewController.h"

enum {
    CAR_TYPE = 0,
    RATE,
    DISTANCE
};

@interface UpKeepViewController ()
{
    IBOutlet    UIButton    *_carTypeBtn;
    IBOutlet    UIButton    *_ratingBtn;
    IBOutlet    UIButton    *_distanceBtn;
    IBOutlet    UITableView *_shopTableView;
    
    NSArray                 *_btnArray;
}
@property (nonatomic, strong) NSArray *shopArray;

@end

@implementation UpKeepViewController

- (void)dealloc
{
    [self.shopArray release];
    [_carTypeBtn release];
    [_ratingBtn release];
    [_distanceBtn release];
    [_shopTableView release];
    [_btnArray release];
    
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
    return [self.shopArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSLocalizedString(@"SHOP_CELL_INDENTIFIER", nil)];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ShopCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[ShopCell class]]) {
                cell = (ShopCell *)aObj;
            }
        }
    }
    [cell applyCell:[self.shopArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shop *shop = [self.shopArray objectAtIndex:indexPath.row];
    ShopDetailsViewController *vc = [[[ShopDetailsViewController alloc] init] autorelease];
    [vc setShop:shop];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- custom methods

- (void)initUI
{
    [super changeTitleView];
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [locationBtn setFrame:CGRectMake(290, 10, 30, 30)];
    [locationBtn addTarget:self action:@selector(calloutLocationViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:locationBtn];
    
    [_carTypeBtn setImage:[UIImage imageNamed:@"choose_car_off"] forState:UIControlStateNormal];
    [_carTypeBtn setImage:[UIImage imageNamed:@"choose_car_on"] forState:UIControlStateHighlighted];
    [_carTypeBtn setImage:[UIImage imageNamed:@"choose_car_on"] forState:UIControlStateSelected];
    [_carTypeBtn setSelected:NO];

    [_ratingBtn setImage:[UIImage imageNamed:@"favourite_off"] forState:UIControlStateNormal];
    [_ratingBtn setImage:[UIImage imageNamed:@"favourite_on"] forState:UIControlStateHighlighted];
    [_ratingBtn setImage:[UIImage imageNamed:@"favourite_on"] forState:UIControlStateSelected];
    [_ratingBtn setSelected:YES];
    
    [_distanceBtn setImage:[UIImage imageNamed:@"distance_off"] forState:UIControlStateNormal];
    [_distanceBtn setImage:[UIImage imageNamed:@"distance_on"] forState:UIControlStateHighlighted];
    [_distanceBtn setImage:[UIImage imageNamed:@"distance_on"] forState:UIControlStateSelected];
    [_distanceBtn setSelected:NO];
    
}

- (void)prepareData
{
    _btnArray = [[NSArray alloc] initWithObjects:_carTypeBtn, _ratingBtn, _distanceBtn, nil];
    
    [[CoreService sharedCoreService] loadHttpURL:@"http://www.xieche.net/index.php/appandroid/get_shops"
           withParams:nil
  withCompletionBlock:^(id data) {
      
      NSMutableArray *tempArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[Shop class]];
      
      self.shopArray = [tempArray subarrayWithRange:NSMakeRange(1, tempArray.count-1)];
      [self sortShopsByRate];
      [_shopTableView reloadData];
  }
       withErrorBlock:^(NSError *error) {
       }];
   
}

- (void)calloutLocationViewController
{
    DLog(@"%d", [self.shopArray count]);
    LocationViewController *vc = [[[LocationViewController alloc] init] autorelease];
    [vc setShopArray:self.shopArray];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buttonPressed:(id)sender
{
    NSInteger index = [_btnArray indexOfObject:sender];
    for (UIButton *btn in _btnArray) {
        [btn setSelected:NO];
    }
    [(UIButton *)sender setSelected:YES];
    
    switch (index) {
        case CAR_TYPE:

            break;
        case RATE:
            [self sortShopsByRate];
            break;
        case DISTANCE:
            [self sortShopsByDistance];
            break;
        default:
            break;
    }

}

- (IBAction)sortShopsByRate
{    
    self.shopArray = [self.shopArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Shop *shop1 = (Shop *)obj1;
        Shop *shop2 = (Shop *)obj2;
        
        if ([shop1.comment_rate integerValue] > [shop2.comment_rate integerValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    [_shopTableView reloadData];
}


- (IBAction)sortShopsByDistance
{
    self.shopArray = [self.shopArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Shop *shop1 = (Shop *)obj1;
        Shop *shop2 = (Shop *)obj2;
        
        if (shop1.distanceFromMyLocation > shop2.distanceFromMyLocation) {
            return NSOrderedDescending;
        }
        return NSOrderedDescending;
    }];
    [_shopTableView reloadData];
}

@end
