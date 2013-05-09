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
    
    if (content && ![content isEqualToString:@"0.00"]) {
        [_contentTextView setText:[NSString stringWithFormat:@"%.1f折优惠",[content doubleValue]*10]];
    }else{
        [_contentTextView setText:@"暂无折扣"];
    }   
    

}

@end
