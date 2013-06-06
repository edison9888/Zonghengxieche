//
//  CouponBtn.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-21.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CouponBtnView.h"
@interface CouponBtnView()
{
    UIImageView     *_bgImageView;
    UIImageView     *_accessoryView;
    UIImageView     *_logoImageView;
    UILabel         *_titleLabel;
    UILabel         *_countLabel;
    UIButton        *_button;
}
@end

@implementation CouponBtnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initCouponBtnViewWithFrame:(CGRect)frame withType:(enum COUPON_TYPE )type
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initUI];
    }

    return  self;
}

- (void)initUI
{
    [self setUserInteractionEnabled:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    _bgImageView = [[[UIImageView alloc] init] autorelease];
    [_bgImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_bgImageView setUserInteractionEnabled:YES];
    UIImage *bgImage = [UIImage imageNamed:@"details_bg"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width/2) topCapHeight:floorf(bgImage.size.height/2)];
    [_bgImageView setImage:bgImage];
    [self addSubview:_bgImageView];
    
    _accessoryView = [[[UIImageView alloc] init] autorelease];
    [_accessoryView setFrame:CGRectMake(self.frame.size.width - self.frame.size.height/3*2-5, self.frame.size.height/6, self.frame.size.height/3*2, self.frame.size.height/3*2)];
    UIImage *accessoryImage = [UIImage imageNamed:@"arrow_icon"];
    accessoryImage = [accessoryImage stretchableImageWithLeftCapWidth:floorf(accessoryImage.size.width/2) topCapHeight:floorf(accessoryImage.size.height/2)];
    [_accessoryView setImage:accessoryImage];
    [_bgImageView addSubview:_accessoryView];
    
    _logoImageView = [[[UIImageView alloc] init] autorelease];
    [_logoImageView setFrame:CGRectMake(10, self.frame.size.height/6, self.frame.size.height/3*2, self.frame.size.height/3*2)];
    UIImage *logoImage;
    if (self.type == QUAN_TYPE) {
        logoImage = [UIImage imageNamed:@"quan_small_icon"];
    }else{
        logoImage = [UIImage imageNamed:@"tuan_small_icon"];
    }
    logoImage = [logoImage stretchableImageWithLeftCapWidth:floorf(logoImage.size.width/2) topCapHeight:floorf(logoImage.size.height/2)];
    [_logoImageView setImage:logoImage];
    [_bgImageView addSubview:_logoImageView];
    
    _titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_logoImageView.frame.size.width + 20, self.frame.size.height/6, self.frame.size.width/5*3, self.frame.size.height/3*2)] autorelease];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [_titleLabel setTextColor:[UIColor darkGrayColor]];
    [_bgImageView addSubview:_titleLabel];
    
    _countLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 10, self.frame.size.height/6, 30, self.frame.size.height/3*2)] autorelease];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    [_countLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [_countLabel setTextColor:[UIColor darkGrayColor]];
    [_bgImageView addSubview:_countLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setFrame:_titleLabel.frame];
    [_button addTarget:self action:@selector(couponButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTag:self.type];
    [self addSubview:_button];
}

- (void)couponButtonPressed:(UIButton *)button
{
    [self.delegate didCouponButtonPressed:button];
}

- (void)setTitle:(NSString *)titleString
{
    [_titleLabel setText:titleString];
}
- (void)setCount:(NSString *)countNumber
{
    [_countLabel setText:countNumber];
}
@end
