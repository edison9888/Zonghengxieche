//
//  PointsCell.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-13.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "PointsCell.h"
#import "Points.h"
@interface PointsCell ()
{
    IBOutlet    UILabel     *_totalPoints;
    IBOutlet    UILabel     *_orderID;

}

@end

@implementation PointsCell


- (void)applyCell:(Points *)points
{
    [_totalPoints setText:points.point_number];
    [_orderID setText:points.order_id];
}

@end
