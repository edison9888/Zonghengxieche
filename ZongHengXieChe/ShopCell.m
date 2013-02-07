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
    [[CoreService sharedCoreService] loadDataWithURL:shop.logo withParams:nil withCompletionBlock:^(id data) {
        [_shopImage setImage:[UIImage imageWithData:(NSData *)data]];
    } withErrorBlock:nil];
    [_titleLabel setText:shop.show_title];
    [_addressLabel setText:shop.shop_address];
    
    DLog(@"%f", (double)shop.distanceFromMyLocation);
    [_distanceLabel setText:[NSString stringWithFormat:@"距离:%.2fkm",shop.distanceFromMyLocation/1000]];
    [_rateLabel setText:[NSString stringWithFormat:@"好评:%@ %%",shop.comment_rate]];
    [_productSaleLabel setText:[NSString stringWithFormat:@"工时费%@起",shop.workhours_sale]];
}

@end
