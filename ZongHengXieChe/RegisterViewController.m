//
//  RegisterViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "RegisterViewController.h"
#import "CoreService.h"

@interface RegisterViewController ()
{
    NSMutableArray *_textfiledArray;
    
    IBOutlet    UIScrollView    *_contentView;
    
    IBOutlet    UITextField     *_email;
    IBOutlet    UITextField     *_username;
    IBOutlet    UITextField     *_password1;
    IBOutlet    UITextField     *_password2;
    IBOutlet    UITextField     *_phone;
    
}

@end

@implementation RegisterViewController

- (void)dealloc
{
    [_textfiledArray release];
    
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
    [_contentView setContentOffset:CGPointMake(0, 40*index) animated:YES];
}


#pragma mark- custom methods
- (void)prepareData
{
    _textfiledArray = [[NSMutableArray alloc] initWithObjects:_email, _username, _password1, _password2, _phone, nil];
}


- (void)initUI
{
    [self setTitle:@"注册纵横携车网"];
    [super changeTitleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    [_contentView setContentSize:CGSizeMake(320, 367)];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)register:(id)sender {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:_email.text forKey:@"email"];
    [dic setObject:_password1.text forKey:@"password"];
    [dic setObject:_password2.text forKey:@"repassword"];
    [dic setObject:_phone.text forKey:@"mobile"];

    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/appinsert"
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

@end
