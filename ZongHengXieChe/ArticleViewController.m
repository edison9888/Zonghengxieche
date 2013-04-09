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
    
    NSInteger       p_count;//总页数
    NSInteger       p;//当前页
    
    //EGO
    BOOL                        _reloading;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    UIActivityIndicatorView     *_refreshSpinner;
}
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) NSMutableDictionary *argumentsDic;
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
    return [_dataArray count];
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
    Article *article = [_dataArray objectAtIndex:indexPath.row];
    
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
    [backBtn setImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];

    [_mineBtn setBackgroundImage:[UIImage imageNamed:@"sale_btn_focus"] forState:UIControlStateSelected];
    [_allBtn setBackgroundImage:[UIImage imageNamed:@"sale_btn_focus"] forState:UIControlStateSelected];
    
    [self createEGORefreshHeader];
}

- (void)prepareData
{
    p = 1;
    [self loadArticles];
    
}

- (void)initArguments
{
    p = 1;
    self.argumentsDic = [[[NSMutableDictionary alloc] init] autorelease];
    [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
}


- (void)loadArticles
{
    [self.loadingView setHidden:NO];
    NSString *urlString = [NSString stringWithFormat:@"http://c.xieche.net/index.php/appandroid/articlelist"];
    [[CoreService sharedCoreService] loadHttpURL:urlString
                                      withParams:self.argumentsDic
                             withCompletionBlock:^(id data) {
                                 
                                 NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 if ([status isEqualToString:@"1"]) {
                                     [self pushLoginVC];
                                 }else{
                                     NSDictionary *params = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                     p_count = [[[[params objectForKey:@"XML"] objectForKey:@"p_count"] objectForKey:@"text"] integerValue];
                                     
                                     NSMutableArray *tempArray = [[CoreService sharedCoreService] convertXml2Obj:(NSString *)data withClass:[Article class]];
                                     if (tempArray.count>0) {
                                         [tempArray removeObjectAtIndex:0];
                                     }

                                     
                                     if (p>1 && p <= p_count ) {
                                         [self.dataArray addObjectsFromArray:tempArray];
                                     }else{
                                         if (p<p_count) {
                                             [self createTableFooter];
                                         }
                                         self.dataArray = tempArray;
                                         
                                     }
                                     p++;
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
        [self initArguments];
        [_mineBtn setSelected:YES];
        [_allBtn setSelected:NO];
        [self.argumentsDic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
        [self loadArticles];
    }else{
        [self pushLoginVC];
    }
}
- (IBAction)getAllArticle:(id)sender {
    [_mineBtn setSelected:NO];
    [_allBtn setSelected:YES];
    [self loadArticles];
}
- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createEGORefreshHeader
{
    if ( !_refreshHeaderView ) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [_myTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void) createTableFooter
{
    _myTableView.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _myTableView.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setBackgroundColor:[UIColor clearColor]];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多"];
    [tableFooterView addSubview:loadMoreText];
    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_refreshSpinner setFrame: CGRectMake(190, _myTableView.tableFooterView.frame.size.height/2+10,20,20)];
    [_refreshSpinner setHidesWhenStopped: YES];
    [tableFooterView addSubview:_refreshSpinner];
    [_myTableView setTableFooterView: tableFooterView];
}


#pragma mark - ego && UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!_reloading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        if (p<=p_count) {
            [self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
            [self loadArticles];
        }else{
            _myTableView.tableFooterView = nil;
        }
    }else if (scrollView.contentOffset.y <= - 65.0f){
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadData];
    [self performSelector:@selector(doneLoadingData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading?NO:_reloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

- (void)reloadData
{
    //[self.argumentsDic setObject:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [self initArguments];
    [self loadArticles];
    _reloading = YES;
}

- (void)doneLoadingData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_myTableView];
}

@end
