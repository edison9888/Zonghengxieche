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
#import "MyCarViewController.h"
#import "Ordering.h"

@interface CarDetailsViewController ()
{
    IBOutlet    UITextField     *_nameField;
    IBOutlet    UIButton        *_paiButton;
    IBOutlet    UITextField     *_numberField;
    IBOutlet    UITextField     *_typeField;
    IBOutlet    UIScrollView    *_contentScrollView;
    
    IBOutlet    UIPickerView    *_picker;
    IBOutlet    UIView          *_pickerView;
    
    
    IBOutlet    UIImageView     *_arrowImage;
    IBOutlet    UIButton        *_carTypeBtn;
    
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




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_nameField resignFirstResponder];
    [_typeField resignFirstResponder];
    [_numberField resignFirstResponder];
}

#pragma mark- picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _regionArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  [_regionArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_paiButton setTitle:[_regionArray objectAtIndex:row] forState:UIControlStateNormal];
}

#pragma mark- custom methods
- (void)prepareData
{
    _regionArray = [[NSArray alloc] initWithObjects:@"京",@"沪",@"港",@"吉",@"鲁",@"冀",@"湘",@"青",@"苏",@"浙",@"粤",@"台",@"甘",@"川",@"黑",@"蒙",@"新",@"津",@"渝",@"澳",@"辽",@"豫",@"鄂",@"晋",@"皖",@"赣",@"闽",@"琼",@"陕",@"云",@"贵",@"藏",@"宁",@"桂", nil];
    [_picker reloadAllComponents];
    
}
- (IBAction)sProSelect:(id)sender {
    [_pickerView setHidden:NO];
    [_nameField resignFirstResponder];
    [_typeField resignFirstResponder];
    [_numberField resignFirstResponder];
    
    [_pickerView setHidden:NO];
    NSString *province  = _paiButton.titleLabel.text;
    NSInteger index = [_regionArray indexOfObject:province];
    [_picker selectRow:index inComponent:0 animated:YES];
}
- (IBAction)carTypeSelect:(id)sender {
    
    if (self.selectedCar) {
        [[CoreService sharedCoreService] setMyCar:self.selectedCar];
    }else{
        [[CoreService sharedCoreService] setMyCar:[[[CarInfo alloc] init] autorelease]];
    }
    CarInfo *mycar = [[CoreService sharedCoreService] myCar];
    [mycar setCar_name:_nameField.text];
    [mycar setCar_number:_numberField.text];
    [mycar setS_pro: _paiButton.titleLabel.text];
    
    CarInfoViewController *vc = [[[CarInfoViewController alloc] init] autorelease];
    [vc setEntrance:ADD_MY_CAR];
    [vc setCarInfo:BRAND];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)initUI
{
    if (self.crudType == ADD) {
        [self setTitle:@"新增车辆"];
        [_arrowImage setHidden:NO];
        [_carTypeBtn setHidden:NO];
    }else{
        [self setTitle:@"编辑车辆"];
        [_arrowImage setHidden:YES];
        [_carTypeBtn setHidden:YES];
    }
    
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    if (self.selectedCar) {
        [self fillCarInfo:self.selectedCar];
        [[CoreService sharedCoreService] setMyCar:self.selectedCar];
    }else{
        [[CoreService sharedCoreService] setMyCar:[[[CarInfo alloc] init] autorelease]];
    }
    
    NSString *province  = _paiButton.titleLabel.text;
    if (!province || [province isEqualToString:@""]) {
        province = @"沪";
    }
    [_paiButton setTitle:province forState:UIControlStateNormal];
    
    [_contentScrollView setContentSize:CGSizeMake(320, self.view.frame.size.height+20)];
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
                           for (UIViewController *v in self.navigationController.viewControllers) {
                               if ([v isKindOfClass:[MyCarViewController class]]) {
                                   [self.navigationController popToViewController:v animated:YES];
                               }
                           }
                           
                       }
                   }else{
                       [self.navigationController popViewControllerAnimated:YES];
                   }
                   
               } withErrorBlock:nil];
}

- (IBAction)hidePicker:(id)sender {
    [_pickerView setHidden:YES];
    
}

@end
