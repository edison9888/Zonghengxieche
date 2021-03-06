//
//  LoginViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "LoginViewController.h"
#import "CoreService.h"
#import "User.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "CustomNavigationBar.h"

enum USER_INFO_TEXTFIELD {
    USERNAME = 1,
    PWD
};

@interface LoginViewController ()
{
    IBOutlet    UITextField     *_usernameField;
    IBOutlet    UITextField     *_pwdField;
    IBOutlet    UIButton        *_loginBtn;
    IBOutlet    UIScrollView    *_contentScrollView;
}

@end

@implementation LoginViewController

- (void)dealloc
{
    [_usernameField release];
    [_pwdField release];
    [_loginBtn release];
    
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
}


- (void)viewWillAppear: (BOOL)animated
{
    if (self.loginType == LOGIN_TYPE_PRESENT) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [((CustomNavigationBar *)[appDelegate customNavigationBar]) setHidden:YES];
    }
    
}

- (void)viewWillDisappear: (BOOL)animated
{
    if (self.loginType == LOGIN_TYPE_PRESENT) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [((CustomNavigationBar *)[appDelegate customNavigationBar]) setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case USERNAME:
            [_usernameField resignFirstResponder];
            [_pwdField becomeFirstResponder];
            break;
        case PWD:
            [self login];
        default:
            break;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case USERNAME:
            [_contentScrollView setContentOffset:CGPointMake(0, 30)];
            break;
        case PWD:
            [_contentScrollView setContentOffset:CGPointMake(0, 70)];
        default:
            break;
    }

}


#pragma mark- custom methods
- (void)initUI
{
    self.title = @"登录我的携车";
    [super changeTitleView];
    [_pwdField setSecureTextEntry:YES];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
    [_contentScrollView setContentSize:CGSizeMake(320, 400)];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastLoginName = [userdefaults objectForKey:LastLoginNameKey];
    if(lastLoginName){
        [_usernameField setText:lastLoginName];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_usernameField resignFirstResponder];
    [_pwdField resignFirstResponder];

}

- (IBAction)login
{
    BOOL isLegal = NO;
    NSString *tipString = @"";
    if ([_usernameField.text length] == 0) {
        tipString = @"用户名不能为空";
    }else if([_pwdField.text length]==0){
        tipString = @"密码不能为空";
    }else{
        isLegal = YES;
    }
    
    if (isLegal) {
        NSMutableDictionary *paramsDic = [[[NSMutableDictionary alloc] init] autorelease];
        [paramsDic setValue:_usernameField.text forKey:@"username"];
        [paramsDic setValue:_pwdField.text forKey:@"password"];
        
        [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/public/applogincheck"
                                          withParams:paramsDic
                                 withCompletionBlock:^(id data) {
                                     NSDictionary *dic = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                     NSString *status = [[[dic objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                     NSString *token = [[[dic objectForKey:@"XML"] objectForKey:@"tolken"] objectForKey:@"text"];
                                     NSString *desc = [[[dic objectForKey:@"XML"] objectForKey:@"desc"] objectForKey:@"text"];
                                     
                                     if ([status isEqualToString:@"0"]) {
                                         User *currentUser = [[CoreService sharedCoreService] currentUser];
                                         [currentUser setUid:[[[dic objectForKey:@"XML"] objectForKey:@"uid"] objectForKey:@"text"]];
                                         [currentUser setUsername:[[[dic objectForKey:@"XML"] objectForKey:@"username"] objectForKey:@"text"]];
                                         [currentUser setPassword:[paramsDic objectForKey:@"password"]];
                                         [currentUser setTruename:[[[dic objectForKey:@"XML"] objectForKey:@"truename"] objectForKey:@"text"]];
                                         [currentUser setToken:token];
                                         [currentUser setEmail:[[[dic objectForKey:@"XML"] objectForKey:@"email"] objectForKey:@"text"]];
                                         [currentUser setMobile:[[[dic objectForKey:@"XML"] objectForKey:@"mobile"] objectForKey:@"text"]];
                                         [currentUser setProv:[[[dic objectForKey:@"XML"] objectForKey:@"prov"] objectForKey:@"text"]];
                                         [currentUser setCity:[[[dic objectForKey:@"XML"] objectForKey:@"city"] objectForKey:@"text"]];
                                         [currentUser setArea:[[[dic objectForKey:@"XML"] objectForKey:@"area"] objectForKey:@"text"]];
                                         [[CoreService sharedCoreService] saveUserToLocal];
                                         
                                         NSDate *date = [NSDate date];
                                         NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                                         [userdefaults setObject:date forKey:LastLoginTimeKey];
                                         [userdefaults setObject:_usernameField.text forKey:LastLoginNameKey];
                                         
                                         [self popToParent];
                                     }else{
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                         [alert show];
                                         [alert release];

                                     
                                     }
                                 }    withErrorBlock:^(NSError *error) {
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败请稍候再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                     [alert show];
                                     [alert release];
                                 }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tipString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)popToParent
{
//    if (self.loginType == LOGIN_TYPE_PRESENT) {
//        [self dismissModalViewControllerAnimated:YES];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Register:(id)sender {
    RegisterViewController *vc = [[[RegisterViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
