//
//  AppRecommendViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-10.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "AppRecommendViewController.h"
#import "RecommendApp.h"
#import "BaseTableViewCell.h"


@interface AppRecommendViewController ()
{
    IBOutlet    UITableView     *_appTableView;
}
@property (strong, nonatomic) NSMutableArray *appArray;
@end

@implementation AppRecommendViewController

- (void)dealloc
{
    [_appArray release];
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
    return [_appArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"APP_RECOMMEND_CELL_IDENTIFIER";
    RecommendApp *app = [self.appArray objectAtIndex:indexPath.row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.imageView setContentMode:UIViewContentModeCenter];
    [cell.textLabel setText:app.appname];

    if (!app.applogo_image) {
        [cell setTitleImageWithUrl:app.applogo withSize:CGSizeMake(60, 60)];
    }else{
        [cell.imageView setImage:app.applogo_image];
    }
        
    [cell.detailTextLabel setNumberOfLines:2];
    [cell.detailTextLabel setText:app.appdes];
    return cell;
}

#pragma  mark- custom methods
- (void)prepareData
{
    [self.loadingView setHidden:NO];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_otherapp"
                                      withParams:nil
                             withCompletionBlock:^(id data) {
                                 self.appArray = [[CoreService sharedCoreService] convertXml2Obj:data withClass:[RecommendApp class]];
                                 [_appTableView reloadData];
                                 [self.loadingView setHidden:YES];
                             } withErrorBlock:nil];
}
- (void)initUI
{
    [self setTitle:@"应用推荐"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
