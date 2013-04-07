//
//  PointsViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-13.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "PointsViewController.h"
#import "CoreService.h"
#import "Points.h"
#import "PointsCell.h"
#import "LoginViewController.h"

@interface PointsViewController ()
{
    IBOutlet    UILabel     *_totalPointsLabel;
    IBOutlet    UITableView *_contentTableView;
}
@property (strong, nonatomic) NSMutableArray    *pointsArray;
@end

@implementation PointsViewController

- (void)dealloc
{
    [_pointsArray release];
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return [self.pointsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSLocalizedString(@"POINTS_CELL_INDENTIFIER", nil)];
    if (!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PointsCell" owner:self options:nil];
        for (id aObj in nibArray) {
            if ([aObj isKindOfClass:[PointsCell class]]) {
                cell = (PointsCell *)aObj;
            }
        }
    }
    [cell applyCell:[self.pointsArray objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark- custom methods
- (void)prepareData
{
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_mypoints"
                                      withParams:dic
                             withCompletionBlock:^(id data) {
                                 
                                 NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 if ([status isEqualToString:@"1"]) {
                                     [self pushLoginVC];
                                 }else{
                                     NSDictionary *dic = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                     
                                     self.pointsArray = [[CoreService sharedCoreService] convertXml2Obj:data withClass:[Points class]];
                                     NSString *totalNumber= [[[dic objectForKey:@"XML"] objectForKey:@"total_number"]objectForKey:@"text"];
                                     [_totalPointsLabel setText:totalNumber];
                                     [_contentTableView reloadData];
                                 }
                                     
                                 
                                 
                            } withErrorBlock:^(NSError *error) {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交失败, 请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                 [alert show];
                                 [alert release];
                             }];

}

- (void)initUI
{
    [self setTitle:@"我的积分"];
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


- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
