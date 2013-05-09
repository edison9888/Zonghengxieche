//
//  UserInfoModifyViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-12.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "UserInfoModifyViewController.h"
#import "CoreService.h"
#import "User.h"
#import "LoginViewController.h"

@interface UserInfoModifyViewController ()
{
    IBOutlet UITextField *_emailField;
    IBOutlet UITextField *_phoneField;
}


@end

@implementation UserInfoModifyViewController


- (void)dealloc {
    
    [super dealloc];
}
- (void)viewDidUnload {
    
    [super viewDidUnload];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    User *user = [[CoreService sharedCoreService] currentUser];
    if (user.email) {
        [_emailField setText:user.email];
    }
    if (user.mobile) {
        [_phoneField setText:user.mobile];
    }
}

#pragma mark- custom methods
- (void)prepareData
{
    
}

- (void)initUI
{
    [self setTitle:@"修改我的信息"];
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

- (IBAction)modify:(UIButton *)sender {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
    [dic setObject:_emailField.text forKey:@"email"];
    [dic setObject:_phoneField.text forKey:@"mobile"];
    
    [[CoreService sharedCoreService] loadHttpURL:@"http://c.xieche.net/index.php/appandroid/save_memberinfo"
                                      withParams:dic
                             withCompletionBlock:^(id data) {
                                 
                                 DLog(@"%@", (NSString *)data);
                                 NSDictionary *result = [[CoreService sharedCoreService] convertXml2Dic:data withError:nil];
                                 NSString *status = [[[result objectForKey:@"XML"] objectForKey:@"status"] objectForKey:@"text"];
                                 NSString *desc = [[[result objectForKey:@"XML"] objectForKey:@"desc"] objectForKey:@"text"];
                                 
                                 if ([status isEqualToString:@"1"]) {
                                     [self pushLoginVC];
                                 }else{
                                 
                                     [[[CoreService sharedCoreService] currentUser] setEmail:_emailField.text];
                                     [[[CoreService sharedCoreService] currentUser] setMobile:_phoneField.text];
                                     
                                     
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                     [alert show];
                                     [alert release];
                                     
                                     if ([status isEqualToString:@"0"]) {
                                         [self popToParent];
                                     }
                                 }
                                 
                                 
                                 
                                 
                             } withErrorBlock:^(NSError *error) {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交失败, 请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                 [alert show];
                                 [alert release];
                             }];
    
}
- (void)pushLoginVC
{
    LoginViewController *vc = [[[LoginViewController alloc] init] autorelease];
    [vc.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _emailField) {
        [_emailField resignFirstResponder];
        [_phoneField becomeFirstResponder];
    }
    if (textField == _phoneField) {
        [_phoneField resignFirstResponder];
    }

    return YES;
}

@end
