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

@interface InfoViewController ()
{
    IBOutlet    UIScrollView    *_contentScrollView;
    IBOutlet    UIButton        *_confirmBtn;
    IBOutlet    UITextField     *_nameField;
    IBOutlet    UITextField     *_phoneField;
    IBOutlet    UITextField     *_carPlateField;
    IBOutlet    UITextField     *_carNumberField;
    IBOutlet    UITextView      *_commentView;
}

@end

@implementation InfoViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark- custom methods
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
}

- (IBAction)confirm
{
    Ordering *myOrdering = [[CoreService sharedCoreService] myOrdering];
    [myOrdering setTruename:_nameField.text];
    [myOrdering setMobile:_phoneField.text];
    [myOrdering setCardqz:_carPlateField.text];
    [myOrdering setLicenseplate:_carNumberField.text];
    
    NSArray *properties = [[CoreService sharedCoreService] getPropertyList:[Ordering class]];
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *propertyName in properties) {
        id value = [myOrdering valueForKey:propertyName];
        if (value) {
            [dic setObject:(NSString *)value forKey:propertyName];
        }
    
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
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                 }
                                 
                                 
                                 
                            } withErrorBlock:nil];
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
