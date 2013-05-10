//
//  LodingView.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
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


-(void)config
{
//    double height =  self.frame.size.height;
//    double width = self.frame.size.width;
    
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame: self.frame];
    if (IS_IPHONE_5) {
        [bg setFrame:CGRectMake(0, 0, 320, 420+88)];
    }
    [bg setBackgroundColor:[UIColor blackColor]];
    [bg setAlpha:0.7];
    [self addSubview:bg];
    [bg release];
    
    UIActivityIndicatorView *activtor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activtor setColor:[UIColor whiteColor]];
    [activtor setFrame:CGRectMake(135, 130, 50, 50)];
    [activtor startAnimating];
    [self addSubview:activtor];
    [activtor release];
    
    [self setHidden:YES];

}
@end
