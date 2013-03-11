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
@interface ArticleViewController ()
{
    IBOutlet    UITableView     *_myTableView;
    NSArray     *_dataArray;
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    Article *article = [_dataArray objectAtIndex:indexPath.row];
    [cell.imageView setImage:article.brand_logo_image];
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
    [self setTitle:@"售后咨询"];
    [super changeTitleView];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
}

- (void)prepareData
{
    [[CoreService sharedCoreService] loadHttpURL:@"http://www.xieche.net/index.php/appandroid/articlelist"
                                          withParams:nil
                                 withCompletionBlock:^(id data) {
                                     _dataArray = [[NSMutableArray alloc] initWithArray:[[CoreService sharedCoreService] convertXml2Obj:data withClass:[Article class]]];
                                     [_myTableView reloadData];
                                    } withErrorBlock:nil];
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
