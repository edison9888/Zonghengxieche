//
//  LoginViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-26.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "LoginViewController.h"
enum USER_INFO_TEXTFIELD {
    USERNAME = 1,
    PWD
};

@interface LoginViewController ()
{
    IBOutlet    UITextField     *_usernameField;
    IBOutlet    UITextField     *_pwdField;
    IBOutlet    UIButton        *_loginBtn;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-
#pragma custom methods
- (void)initUI
{
    [_pwdField setSecureTextEntry:YES];

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
        
        
        [super loadHttpURL:@"http://www.xieche.net/index.php/public/applogincheck"
                withParams:paramsDic
       withCompletionBlock:^(id data) {
        DLog(@"%@",data);
       }    withErrorBlock:^(NSError *error) {
        
       }];
        
 
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tipString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

- (BOOL)isLoginInfoLegal
{
    
    

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

}

@end
