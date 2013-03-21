//
//  ProductSaleView.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-21.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "ProductSaleView.h"

@interface ProductSaleView()
{
    IBOutlet    UITextView      *_contentTextView;
}

@end


@implementation ProductSaleView

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

- (void)setContentText:(NSString *)content
{
    [_contentTextView setText:content];
}

@end
