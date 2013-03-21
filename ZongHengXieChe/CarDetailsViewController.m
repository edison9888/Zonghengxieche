//
//  CarDetailsViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-14.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CarDetailsViewController.h"
#import "CoreService.h"
#import "CarInfoViewController.h"
#import "Ordering.h"

@interface CarDetailsViewController ()
{
    IBOutlet    UITextField     *_nameField;
    IBOutlet    UIButton        *_paiButton;
    IBOutlet    UITextField     *_numberField;
    IBOutlet    UITextField     *_typeField;
    IBOutlet    UITableView     *_regionTableView;
    
    NSArray     *_regionArray;
}

@property (nonatomic, strong)CarInfo *selectedCar;
@end

@implementation CarDetailsViewController

- (void)dealloc
{
    [_selectedCar release];
    [_regionArray release];
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
    return [_regionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"REGION_CELL_IDENTIFIER";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    [cell.textLabel setText:[_regionArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_paiButton.titleLabel setText:[_regionArray objectAtIndex:indexPath.row]];
    [_regionTableView setHidden:YES];
}


#pragma mark- custom methods
- (void)prepareData
{
    _regionArray = [[NSArray alloc] initWithObjects:@"京",@"沪",@"港",@"吉",@"鲁",@"冀",@"湘",@"青",@"苏",@"浙",@"粤",@"台",@"甘",@"川",@"黑",@"蒙",@"新",@"津",@"渝",@"澳",@"辽",@"豫",@"鄂",@"晋",@"皖",@"赣",@"闽",@"琼",@"陕",@"云",@"贵",@"藏",@"宁",@"桂", nil];
    [_regionTableView reloadData];
    
}
- (IBAction)sProSelect:(id)sender {
    [_regionTableView setHidden:NO];
}
- (IBAction)carTypeSelect:(id)sender {
    CarInfoViewController *vc = [[[CarInfoViewController alloc] init] autorelease];
    [vc setEntrance:ADD_MY_CAR];
    [vc setCarInfo:BRAND];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)initUI
{
    [self setTitle:@"编辑车辆"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    if (self.selectedCar) {
        [self fillCarInfo:self.selectedCar];
    }
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)fillCarInfo:(CarInfo *)selectedCar
{
    self.selectedCar = selectedCar;
    
    [_nameField setText:selectedCar.car_name];
    [_paiButton setTitle:selectedCar.s_pro forState:UIControlStateNormal];
    [_numberField setText:selectedCar.car_number];
    [_typeField setText:[NSString stringWithFormat:@"%@ %@ %@", selectedCar.brand_name, selectedCar.series_name, selectedCar.model_name]];
}

- (IBAction)confirm:(id)sender {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];

    [dic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
    [dic setObject:_nameField.text forKey:@"car_name"];
    [dic setObject:_paiButton.titleLabel.text forKey:@"s_pro"];
    [dic setObject:_numberField.text forKey:@"car_number"];
//    [dic setObject:[[[CoreService sharedCoreService]myCar] brand_id] forKey:@"brand_id"];
//    [dic setObject:[[[CoreService sharedCoreService]myCar] series_id] forKey:@"series_id"];
    if ([[CoreService sharedCoreService]myCar] && [[[CoreService sharedCoreService]myCar] brand_id]) {
            [dic setObject:[[[CoreService sharedCoreService]myCar] brand_id] forKey:@"brand_id"];
    }else{
        [dic setObject:self.selectedCar.brand_id forKey:@"brand_id"];
    }
    if ([[CoreService sharedCoreService]myCar] && [[[CoreService sharedCoreService]myCar] series_id]) {
        [dic setObject:[[[CoreService sharedCoreService]myCar] series_id] forKey:@"series_id"];
    }else{
        [dic setObject:self.selectedCar.model_id forKey:@"series_id"];
    }
    if ([[CoreService sharedCoreService]myCar] && [[[CoreService sharedCoreService]myCar] model_id]) {
        [dic setObject:[[[CoreService sharedCoreService]myCar] model_id] forKey:@"model_id"];
    }else{
        [dic setObject:self.selectedCar.model_id forKey:@"model_id"];
    }
    if ([[CoreService sharedCoreService]myCar] && [[[CoreService sharedCoreService]myCar] u_c_id]) {
        [dic setObject:[[[CoreService sharedCoreService]myCar] u_c_id] forKey:@"u_c_id"];
    }else{
        [dic setObject:self.selectedCar.model_id forKey:@"u_c_id"];
    }
    
    
    NSString *URL = @"http://c.xieche.net/index.php/appandroid/add_membercar";
    if (self.crudType == UPDATE) {
        URL = @"http://c.xieche.net/index.php/appandroid/update_membercar";
    }
    
    [self.loadingView setHidden:NO];
    
    [[CoreService sharedCoreService]loadHttpURL:URL
               withParams:dic withCompletionBlock:^(id data) {
                   DLog("%@",(NSString *)data);
                   [self.loadingView setHidden:YES];
                   if (self.crudType == UPDATE) {
                       NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                       NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                       NSString *desc = [[[result objectForKey:@"XML"] objectForKey:@"desc"] objectForKey:@"text"];
                       
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                       [alert show];
                       [alert release];
                       if ([status isEqualToString:@"0"]) {
                           [self.navigationController popToRootViewControllerAnimated:YES];
                       }
                   }else{
                       [self.navigationController popViewControllerAnimated:YES];
                   }
                   
               } withErrorBlock:nil];
}


@end
