//
//  ShopCell.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-1.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ShopCell.h"
#import "Shop.h"
#import "CoreService.h"

@interface ShopCell()
{
    IBOutlet    UIImageView     *_shopImage;
    IBOutlet    UIImageView     *_shopClassImage;
    IBOutlet    UILabel         *_titleLabel;
    IBOutlet    UILabel         *_addressLabel;
    IBOutlet    UILabel         *_distanceLabel;
    IBOutlet    UIImageView     *_quanImage;
    IBOutlet    UIImageView     *_tuanImage;
    IBOutlet    UILabel         *_rateLabel;
    IBOutlet    UILabel         *_productSaleLabel;
}

@end

@implementation ShopCell

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

- (void)applyCell:(Shop *)shop
{
    NSString *handledUrlString = [shop.logo stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    handledUrlString = [handledUrlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@",docDir, handledUrlString];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [_shopImage setImage:image];
    }else{
        [[CoreService sharedCoreService] loadDataWithURL:shop.logo withParams:nil withCompletionBlock:^(id data) {
            [_shopImage setImage:[UIImage imageWithData:(NSData *)data]];
        } withErrorBlock:nil];
    }
    
    [_titleLabel setText:shop.shop_name];
    [_addressLabel setText:shop.shop_address];
    
    [_shopClassImage setHidden:![shop.shop_class isEqualToString:@"1"]];
    [_quanImage setHidden:![shop.have_coupon1 isEqualToString:@"1"]];
    [_tuanImage setHidden:![shop.have_coupon2 isEqualToString:@"1"]];

    if ([shop.distance doubleValue]<=1000) {
        [_distanceLabel setText:[NSString stringWithFormat:@"距离:%.2fm",[shop.distance doubleValue]]];
    }else if ([shop.distance doubleValue]>100000) {
        [_distanceLabel setText:[NSString stringWithFormat:@"距离>%.1fkm",100.00]];
    }else{
        [_distanceLabel setText:[NSString stringWithFormat:@"距离:%.2fkm",[shop.distance doubleValue]/1000]];
    }
    [_rateLabel setText:[NSString stringWithFormat:@"好评:%@ %%",shop.comment_rate]];
    
    if (!shop.workhours_sale || [shop.workhours_sale isEqualToString:@""]) {
        [_productSaleLabel setText:[NSString stringWithFormat:@"暂无工时折扣",nil]];
    }else{
        [_productSaleLabel setText:[NSString stringWithFormat:@"工时费%@起",shop.workhours_sale]];
    }
    

}

@end
