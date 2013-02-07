//
//  ShopDetailsViewController.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-7.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ShopDetailsViewController.h"

enum {
    TITLE,
    ADDRESS,
    RATE,
    DISCOUNT,
    BOOKING
};

#define numberOfSections     5
@interface ShopDetailsViewController ()
{
    IBOutlet UITableView   *_detailsTableView;
}

@end

@implementation ShopDetailsViewController

- (void) dealloc
{
    [_detailsTableView release];
    [self.shop release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initUI];
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


#pragma mark- tableview delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == BOOKING) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TITLE:
        {
            return 110.0f;
        }
            break;
            
        default:
        {
            return 110.0f;
        }
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *identifier;
    
    switch (indexPath.section) {
        case TITLE:
        {
            identifier = @"titleCellIndentifier";
            cell = (TitleCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[TitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
            }
            cell.backgroundView = nil;
            [((TitleCell *)cell) applyCell: self.shop];
        }
            break;
            
        default:
        {
            cell = [[[UITableViewCell alloc] init] autorelease];
        }
            break;
    }
    return cell;
}

#pragma  mark- custom methods
- (void)initUI
{

}

@end





@interface TitleCell()
{
    UIImageView     *_logoImageView;
    UILabel         *_titleLabel;
    UITextView      *_describeTextView;
}

@end

@implementation TitleCell

- (void)dealloc
{
    [_logoImageView release];
    [_titleLabel release];
    [_describeTextView release];
    
    [self.shop release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)applyCell:(Shop *)shop
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.shop = shop;
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 80)];
    [_logoImageView setImage: self.shop.logoImage];
    [self addSubview:_logoImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 210, 25)];
    [_titleLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:17]];
    [_titleLabel setText:self.shop.shop_name];
    [self addSubview:_titleLabel];
    
    _describeTextView = [[UITextView alloc] initWithFrame:CGRectMake(110, 35, 210, 45)];
    [_describeTextView setText:self.shop.shop_name];
    [self addSubview:_describeTextView];
    
}

@end