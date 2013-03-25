//
//  TimeSaleView.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-21.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "TimeSaleView.h"

@interface TimeSaleView()
{
    IBOutlet    UILabel     *_timeLabel;
    IBOutlet    UILabel     *_discountLabel;
    IBOutlet    UILabel     *_weekLabel;
    IBOutlet    UIButton    *_bookingBtn;

}
@end


@implementation TimeSaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)fillInfo:(TimeSale *)timesale
{
    [_timeLabel setText:[NSString stringWithFormat:@"%@ -- %@", timesale.begin_time, timesale.end_time]];
    [_discountLabel setText:[NSString stringWithFormat:@"工时费%.1f折", [timesale.workhours_sale doubleValue]*10]];
    [_weekLabel setText:[timesale getWeekday]];
    [_bookingBtn setTag:[timesale.timesale_id integerValue]];
}

- (IBAction)timeSaleBtnPressed:(UIButton *)sender {
    [self.delegate didTimeSaleButtonPressed:sender];
}

@end
