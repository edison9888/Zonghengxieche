//
//  ApplicationViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-10.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ApplicationViewController.h"
#import "CarInfo.h"
#import "CoreService.h"
@interface ApplicationViewController ()
{
    IBOutlet    UITableView     *_brandTableView;
    
    IBOutlet    UIScrollView    *_contentView;
    
    IBOutlet    UITextField     *_nameFiled;
    IBOutlet    UITextField     *_brandFiled;
    IBOutlet    UITextField     *_cityFiled;
    IBOutlet    UITextField     *_linkmanFiled;
    IBOutlet    UITextField     *_telFiled;
    IBOutlet    UITextField     *_qqFiled;
    IBOutlet    UITextField     *_emailFiled;
    
    NSMutableArray *_sectionTitleArray;
    NSMutableArray *_classifiedInfoArray;
    
    NSMutableArray *_textfiledArray;
}
@property (nonatomic, strong) CarInfo *selectedCar;

@end

@implementation ApplicationViewController

- (void)dealloc
{
    [_selectedCar release];
    [_sectionTitleArray release];
    [_classifiedInfoArray release];
    
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
    // Do any additional setup after loading the view from its nib.、
    [self prepareData];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- tableview datasource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    DLog(@"[self.dataArray count] = %d",[self.dataArray count]);
    return [[_classifiedInfoArray objectAtIndex:section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"CAR_INFO_INDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    [cell.textLabel setText:[[[_classifiedInfoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] brand_name]];
    
    return  cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionTitleArray;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_sectionTitleArray indexOfObject:title];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitleArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfo *carInfo = [[_classifiedInfoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    self.selectedCar = carInfo;
    [_brandTableView setHidden:YES];
    [_brandFiled setText:self.selectedCar.brand_name];
}

#pragma mark- scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (UITextField *field in _textfiledArray) {
        [field resignFirstResponder];
    }
}


#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger index = [_textfiledArray indexOfObject:textField];
    [_contentView setContentOffset:CGPointMake(0, 100+40*index) animated:YES];
}


#pragma mark- custom methods
- (void)prepareData
{
    _sectionTitleArray = [[NSMutableArray alloc] init];
    _classifiedInfoArray = [[NSMutableArray alloc] init];
    
    _textfiledArray = [[NSMutableArray alloc] initWithObjects:_nameFiled, _brandFiled, _cityFiled, _linkmanFiled, _telFiled, _qqFiled, _emailFiled, nil];
    
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/get_allbrands"
                                      withParams:nil
                             withCompletionBlock:^(id data) {
                                 NSArray *dataArray = [[NSArray alloc] initWithArray:[[CoreService sharedCoreService] convertXml2Obj:data withClass:[CarInfo class]]];
                                 for (CarInfo *info in dataArray) {
                                     if (info.word) {
                                         if (![_sectionTitleArray containsObject:info.word]) {
                                             [_sectionTitleArray addObject:info.word];
                                             NSMutableArray *array = [[NSMutableArray alloc] init];
                                             [_classifiedInfoArray addObject:array];
                                             [array release];
                                         }
                                         NSInteger index = [_sectionTitleArray indexOfObject:info.word];
                                         [[_classifiedInfoArray objectAtIndex:index] addObject:info];
                                     }else{
                                         if (![_sectionTitleArray containsObject:@"ALL"]) {
                                             [_sectionTitleArray addObject:@"ALL"];
                                             NSMutableArray *array = [[NSMutableArray alloc] init];
                                             [_classifiedInfoArray addObject:array];
                                             [array release];
                                         }
                                         [[_classifiedInfoArray objectAtIndex:0] addObject:info];
                                     }
                                 }
                                 [dataArray release];
                                 [_brandTableView reloadData];
                             } withErrorBlock:nil];
    
}


- (void)initUI
{
    [self setTitle:@"签约用户申请"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    [_contentView setContentSize:CGSizeMake(320, 500)];
    
}
   
- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commit:(UIButton *)sender {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:_nameFiled.text forKey:@"shop_name"];
    [dic setObject:self.selectedCar.brand_id forKey:@"brand_id"];;
    [dic setObject:_cityFiled.text forKey:@"city"];
    [dic setObject:_linkmanFiled.text forKey:@"username"];
    [dic setObject:_qqFiled.text forKey:@"phone"];
    [dic setObject:_telFiled.text forKey:@"qq"];
    [dic setObject:_emailFiled.text forKey:@"email"];
    
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/shopapplyadd"
                                     withParams:dic
                             withCompletionBlock:^(id data) {
                                 DLog(@"%@", (NSString *)data);
                                 NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 NSString *desc = [[[result objectForKey:@"XML"] objectForKey:@"desc"] objectForKey:@"text"];
                                 
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                 [alert show];
                                 [alert release];
                                 
                                 if ([status isEqualToString:@"0"]) {
                                     [self popToParent];
                                 }
                                 
                             } withErrorBlock:^(NSError *error) {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交失败, 请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                 [alert show];
                                 [alert release];
    }];
}

- (IBAction)selectBrand:(UIButton *)sender {
    [_brandTableView setHidden:NO];
}
@end
