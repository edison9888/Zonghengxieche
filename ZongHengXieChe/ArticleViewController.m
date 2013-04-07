//
//  AfterSaleViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-23.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ArticleViewController.h"
#import "CoreService.h"
#import "Article.h"
#import "ArticleDetailViewController.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "BaseTableViewCell.h"
#import "LoginViewController.h"

@interface ArticleViewController ()
{
    IBOutlet    UITableView     *_myTableView;
    IBOutlet    UIButton        *_allBtn;
    IBOutlet    UIButton        *_mineBtn;
}
@property (nonatomic, strong) NSMutableArray    *dataArray;
@end

@implementation ArticleViewController

- (void)dealloc
{
    [_dataArray release];
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
- (void)viewWillAppear: (BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [((CustomTabBarController *)[appDelegate tabbarController]) hideTabbar:YES];
}

- (void)viewWillDisappear: (BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [((CustomTabBarController *)[appDelegate tabbarController]) hideTabbar:NO];
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


#pragma mark- tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count]-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"AFTER_SALE_INDENTIFIER";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    Article *article = [_dataArray objectAtIndex:indexPath.row+1];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setTitleImageWithUrl:article.brand_logo withSize:CGSizeMake(60, 45)];
    [cell.textLabel setText:article.article_title];
    [cell.detailTextLabel setText:article.article_des];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = [_dataArray objectAtIndex:indexPath.row];
    ArticleDetailViewController *vc = [[[ArticleDetailViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [vc setArticle:article];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"售后资讯"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];

    [_mineBtn setBackgroundImage:[UIImage imageNamed:@"sale_btn_focus"] forState:UIControlStateSelected];
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"sale_btn_focus"] forState:UIControlStateSelected];
}

- (void)prepareData
{
    [self loadArticles:nil];
}

- (void)loadArticles: (NSMutableDictionary *)argumentsDic
{
    [self.loadingView setHidden:NO];
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/articlelist"
                                      withParams:argumentsDic
                             withCompletionBlock:^(id data) {
                                 
                                 NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 if ([status isEqualToString:@"1"]) {
                                     [self pushLoginVC];
                                 }else{
                                     self.dataArray = [[CoreService sharedCoreService] convertXml2Obj:data withClass:[Article class]];
                                     [_myTableView reloadData];
                                     [self.loadingView setHidden:YES];
                                 }
                                 
                             } withErrorBlock:^(NSError *error) {
                                 [self.loadingView setHidden:YES];
                             }];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getMyArticle:(id)sender {
    
    User *user = [[CoreService sharedCoreService] currentUser];
    if (user.token) {
        [_mineBtn setSelected:YES];
        [_allBtn setSelected:NO];
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
        [self loadArticles:dic];
    }else{
        [self pushLoginVC];
    }
    
    
}
- (IBAction)getAllArticle:(id)sender {
    [_mineBtn setSelected:NO];
    [_allBtn setSelected:YES];
    [self loadArticles:nil];
}
- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
