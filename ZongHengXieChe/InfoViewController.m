//
//  InfoViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-23.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "InfoViewController.h"
#import "Ordering.h"
#import "CoreService.h"
#import "User.h"
#import "MyAccountViewController.h"
#import "CustomTabBarController.h"
#import "MyAccountViewController.h"

@interface InfoViewController ()
{
    IBOutlet    UIScrollView    *_contentScrollView;
    IBOutlet    UIButton        *_confirmBtn;
    IBOutlet    UITextField     *_nameField;
    IBOutlet    UITextField     *_phoneField;
    IBOutlet    UIButton        *_carPlateBtn;
    IBOutlet    UITextField     *_carNumberField;
    IBOutlet    UITextView      *_commentView;
    
    IBOutlet    UIView          *_pickerView;
    IBOutlet    UIPickerView    *_picker;
}
@property (nonatomic, strong) NSArray *provinceArray;
@end

@implementation InfoViewController

- (void)dealloc
{
    [_provinceArray release];
    
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
    [_phoneField resignFirstResponder];
    [_commentView resignFirstResponder];
    [_carNumberField resignFirstResponder];
}

#pragma mark- picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.provinceArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  [self.provinceArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_carPlateBtn.titleLabel setText:[self.provinceArray objectAtIndex:row]];
}


#pragma  mark- custom methods
- (void)prepareData
{
    self.provinceArray = [[CoreService sharedCoreService] getPlateProvinceArray];
}
- (void)initUI
{
    [self setTitle:@"3/3 基本信息"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    
    UIImage *confirm = [UIImage imageNamed:@"confirm_btn"];
    [_confirmBtn setBackgroundImage:[confirm stretchableImageWithLeftCapWidth:confirm.size.width/2 topCapHeight:confirm.size.height/2] forState:UIControlStateNormal];
    
    if (IS_IPHONE_5) {
        _contentScrollView.contentSize = CGSizeMake(320, 600);
    }else{
        _contentScrollView.contentSize = CGSizeMake(320, 500);
    }
    
    [self fillUserInfo];
}


- (void)fillUserInfo
{
    User *user = [[CoreService sharedCoreService] currentUser];
    if (user.truename) {
        [_nameField setText:user.truename];
    }
    if (user.mobile) {
        [_phoneField setText:user.mobile];
    }
    
    CarInfo *car = [[CoreService sharedCoreService] myCar];
    if (car.car_number) {
        [_carNumberField setText:car.car_number];
    }
    
}

- (BOOL)isRequiredInfoFilled
{
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"请填写姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return NO;
    }
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"请填写手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    
    if (![self isPureInt:_phoneField.text] || [_phoneField.text length] != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码必须是的11位数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [_phoneField becomeFirstResponder];
        return NO;   
    }
    
    if (!_carNumberField.text || [_carNumberField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"请填写车牌号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}



- (IBAction)confirm
{
    if ([self isRequiredInfoFilled]) {    
        Ordering *myOrdering = [[CoreService sharedCoreService] myOrdering];
        [myOrdering setTruename:_nameField.text];
        [myOrdering setMobile:_phoneField.text];
        [myOrdering setCardqz:_carPlateBtn.titleLabel.text];
        [myOrdering setLicenseplate:_carNumberField.text];
        [myOrdering setRemark:_commentView.text];
        
        NSArray *properties = [[CoreService sharedCoreService] getPropertyList:[Ordering class]];
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        for (NSString *propertyName in properties) {
            id value = [myOrdering valueForKey:propertyName];
            if (value && [value isKindOfClass:[NSString class]]) {
                [dic setObject:(NSString *)value forKey:propertyName];
            }
        }
        User *user = [[CoreService sharedCoreService] currentUser];
        if (user.token) {
            [dic setObject:user.token forKey:@"tolken"];
        }
        
        [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/save_order"
                                          withParams:dic
                                 withCompletionBlock:^(id data) {
                                     DLog(@"提交订单结果: %@",data);
                                     NSDictionary *dic = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                     NSString *status = [[[dic objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                     NSString *desc = [[[dic objectForKey:@"XML"] objectForKey:@"desc"] objectForKey:@"text"];
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                     [alert show];
                                     [alert release];
                                     if ([status isEqualToString:@"0"]) {
                                         for (UIViewController *v in self.navigationController.viewControllers) {
                                             if ([v isKindOfClass:[MyAccountViewController class]]) {
                                                 [self.navigationController popToViewController:v animated:YES];
                                             }
                                         }
                                    
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                     }
                                } withErrorBlock:nil];
    }
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)carPlateSelect:(UIButton *)sender {
    [_nameField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_carNumberField resignFirstResponder];
    
    [_pickerView setHidden:NO];
    NSString *province  = _carPlateBtn.titleLabel.text;
    if (!province || [province isEqualToString:@""]) {
        province = @"沪";
    }
    NSInteger index = [self.provinceArray indexOfObject:province];
    [_picker selectRow:index inComponent:0 animated:YES];

}
- (IBAction)hidePickerView:(UIButton *)sender {
    [_pickerView setHidden:YES];
}
- (void)backToHome
{
    [((CustomTabBarController *)self.tabBarController) setSelectedTab :-1];
    MyAccountViewController *vc = [[[MyAccountViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:NO];
}
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
