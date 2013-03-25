//
//  TimeSaleView.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-21.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSale.h"

@protocol TimeSaleDelegate
@optional
- (void)didTimeSaleButtonPressed:(UIButton *)button;
@end

@interface TimeSaleView : UIView

@property (nonatomic, assign) id delegate;

- (void)fillInfo:(TimeSale *)timesale;
- (IBAction)timeSaleBtnPressed:(UIButton *)sender;
@end
