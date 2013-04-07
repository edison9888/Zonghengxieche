//
//  PasswordModifyViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-12.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "PasswordModifyViewController.h"
#import "CoreService.h"
#import "LoginViewController.h"

@interface PasswordModifyViewController ()
{
    IBOutlet    UITextField     *_pwdField1;
    IBOutlet    UITextField     *_pwdField2;
    IBOutlet    UITextField     *_pwdField3;
}

@end

@implementation PasswordModifyViewController

- (void)dealloc
{
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

#pragma mark- custom methods
- (void)prepareData
{
    
}

- (void)initUI
{
    [self setTitle:@"修改账户密码"];
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


- (IBAction)modify:(id)sender {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:[[[CoreService sharedCoreService] currentUser] uid] forKey:@"uid"];
    [dic setObject:[[[CoreService sharedCoreService] currentUser] token] forKey:@"tolken"];
    [dic setObject:_pwdField1.text forKey:@"oldpassword"];
    [dic setObject:_pwdField2.text forKey:@"password"];
    [dic setObject:_pwdField3.text forKey:@"repassword"];
    
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
                                     [[[CoreService sharedCoreService] currentUser] setPassword:_pwdField2.text];
                                     
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
@end
