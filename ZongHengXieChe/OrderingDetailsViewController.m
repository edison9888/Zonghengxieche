//
//  OrderingDetailsViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "OrderingDetailsViewController.h"
#import "CoreService.h"
#import "OrderingCell.h"
#import "OrderingOptionCell.h"

enum ORDERING_CELL {
    ORDERING_CELL = 0,
    ORDERING_LABEL_CELL = 1,
    ORDERING_OPTION_CELL
};


@interface OrderingDetailsViewController ()
{
    IBOutlet    UITableView     *_myTableView;
}

@end

@implementation OrderingDetailsViewController
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

#pragma mark- tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case ORDERING_CELL:
            return 250.0;
            break;
        case ORDERING_LABEL_CELL:
            return 45.0;
        default:
            return 45.0;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    switch (indexPath.row) {
        case ORDERING_CELL:
            identifier = @"ORDERING_CELL_INDENTIFIER";
            break;
        case ORDERING_LABEL_CELL:
            identifier = @"ORDERING_LABEL_CELL_INDENTIFIER";
        default:
            identifier = @"ORDERING_OPTION_CELL_INDENTIFIER";
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        switch (indexPath.row) {
            case ORDERING_CELL:
            {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OrderingCell" owner:self options:nil];
                for (id aObj in nibArray) {
                    if ([aObj isKindOfClass:[OrderingCell class]]) {
                        cell = (OrderingCell *)aObj;
                    }
                }
            }
                break;
            case ORDERING_LABEL_CELL:
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
                [cell.textLabel setText:@"通过纵横携车网预约您的维修项目,共为您节省:"];
            }
                break;
            default:
            {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OrderingOptionCell" owner:self options:nil];
                for (id aObj in nibArray) {
                    if ([aObj isKindOfClass:[OrderingOptionCell class]]) {
                        cell = (OrderingOptionCell *)aObj;
                    }
                }
            }
                break;
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma  mark- custom methods
- (void)initUI
{
    [self setTitle:@"预约详情"];
    [super changeTitleView];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 3, 35, 35)];
    [backBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:backBtn];
}

- (void)prepareData
{
    
}

- (void)popToParent
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
