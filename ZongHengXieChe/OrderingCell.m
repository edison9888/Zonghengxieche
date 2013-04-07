//
//  OrderingCell.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "OrderingCell.h"
#import <QuartzCore/QuartzCore.h>

@interface OrderingCell ()
{
    IBOutlet    UIImageView *_bgImage;
    IBOutlet    UILabel     *_orderingIdLabel;
    IBOutlet    UILabel     *_createTimeLabel;
    IBOutlet    UILabel     *_shopNameLabel;
    IBOutlet    UILabel     *_timeSaleLabel;
    IBOutlet    UILabel     *_orderingTimeLabel;
    IBOutlet    UILabel     *_orderStatusLabel;
    IBOutlet    UIImageView *_shopImageView;
}

@end

@implementation OrderingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)applyOrderingCell:(Ordering *)ordering
{
    UIImage *bgimage = [UIImage imageNamed:@"textfiled_bg"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:floorf(bgimage.size.width/2) topCapHeight:floorf(bgimage.size.height/2)];
    [_bgImage setImage:bgimage];
    
    [_orderingIdLabel setText:ordering.order_id];
    [_createTimeLabel setText:ordering.create_time];
    [_shopNameLabel setText:ordering.shop_name];
    [_timeSaleLabel setText:[NSString stringWithFormat:@"%.1f折",[ordering.workhours_sale doubleValue]*10]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[ordering.order_time doubleValue]];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    NSString *orderingTime = [dateFormatter stringFromDate:date];
    [_orderingTimeLabel setText:orderingTime];
    [_orderStatusLabel setText:ordering.order_state_str];
     [_shopImageView setImage:[UIImage imageNamed:@"loading"]];
    [[CoreService sharedCoreService] loadDataWithURL:ordering.logo
                                          withParams:nil
                                 withCompletionBlock:^(id data) {
                                     [_shopImageView setImage:[UIImage imageWithData:data]];
                                    } withErrorBlock:nil];    
}

@end
