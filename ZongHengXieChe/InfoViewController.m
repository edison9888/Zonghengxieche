//
//  InfoViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-23.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
{
    IBOutlet    UIButton        *_confirmBtn;
    IBOutlet    UITextField     *_nameField;
    IBOutlet    UITextField     *_phoneField;
    IBOutlet    UITextField     *_carPlateField;
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

}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
