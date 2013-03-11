//
//  OptionCell.m
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "OptionCell.h"

@interface OptionCell()
{
   IBOutlet UIImageView *_logoImageView;
   IBOutlet UILabel     *_titleLabel;
   IBOutlet UILabel     *_detailsLabel;
}

@end


@implementation OptionCell

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

- (void)applyCell:(Option *)option
{
    [_logoImageView setImage:option.icon];
    [_titleLabel setText:option.title];
    [_detailsLabel setText:option.details];
}

@end
