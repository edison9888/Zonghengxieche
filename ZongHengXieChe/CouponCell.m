//
//  CouponCell.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-24.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CouponCell.h"
#import "Coupon.h"
#import "CoreService.h"
@interface CouponCell ()
{
    IBOutlet    UIImageView     *_logoImage;
    IBOutlet    UIImageView     *_typeImage;
    IBOutlet    UILabel         *_nameLabel;
    IBOutlet    UILabel         *_costLabel;
    IBOutlet    UILabel         *_discountLabel;
    IBOutlet    UILabel         *_payCountLabel;
    IBOutlet    UILabel         *_couponDistanceLabel;
    IBOutlet    UILabel         *_endTimeLabel;


}

@end

@implementation CouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)applyCell:(Coupon *)coupon
{
    if (coupon) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[coupon.end_time doubleValue]];
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *endTimeStr = [dateFormatter stringFromDate:date];
        
        
        [_typeImage setImage:[UIImage imageNamed:[coupon.coupon_type isEqualToString:@"1"]?@"quan_small_icon":@"tuan_small_icon"]];
        [_nameLabel setText:coupon.coupon_name];
        [_costLabel setText:[NSString stringWithFormat:@"¥ %@", coupon.coupon_amount]];
        [_discountLabel setText:[NSString stringWithFormat:@"¥ %@", coupon.cost_price]];
        [_endTimeLabel setText:[NSString stringWithFormat:@"到期:%@", endTimeStr]];
                [[CoreService sharedCoreService] loadDataWithURL:coupon.coupon_logo
                                              withParams:nil withCompletionBlock:^(id data) {
                                                  [_logoImage setImage:[UIImage imageWithData:data]];
                                              } withErrorBlock:nil];
        
        if (self.entrance == ENTRANCE_MYCASH || self.entrance == ENTRANCE_MYTUAN) {
            [_couponDistanceLabel setText:[self getStatus:coupon]];
            if ([coupon.is_pay isEqualToString:@"1"]) {
                [_payCountLabel setText:[NSString stringWithFormat:@"消费码:%@",coupon.coupon_code]];
            }
        }else{
            [_couponDistanceLabel setText:[NSString stringWithFormat:@"距离:%.1fkm", [coupon.distance doubleValue]/1000]];
            [_payCountLabel setText:[NSString stringWithFormat:@"已有%@人购买", coupon.pay_count]];
        }
    }
}

- (NSString *)getStatus:(Coupon *)coupon
{
    if (coupon.is_overtime && [coupon.is_overtime isEqualToString:@"1"]) {
        return @"已过期";
    }else if (coupon.is_pay && [coupon.is_pay isEqualToString:@"0"]) {
        return @"未支付";
    }else if (coupon.is_use && [coupon.is_use isEqualToString:@"0"]){
        return @"未使用";
    }else{
        return @"已使用";
    }
    

}

@end
