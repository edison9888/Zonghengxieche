//
//  CalloutMapAnnotationView.m
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "CalloutMapAnnotationView.h"
#import <QuartzCore/QuartzCore.h> 
#import "ShopDetailsViewController.h"

#define  Arror_height 0

@interface CalloutMapAnnotationView()
{
    UILabel *_titleLabel;
    UILabel *_timesaleLabel;
    UIImageView *_discountImageView;
    UIButton  *_toDetailsBtn;
    
}
@end

@implementation CalloutMapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)dealloc{
    [_titleLabel release];
    [_timesaleLabel release];
    [_discountImageView release];
    [_contentView release];
    [_shop release];
    
    [super dealloc];
}

-(void)drawRect:(CGRect)rect{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

-(void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.7];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -55);
        self.frame = CGRectMake(0, 0, 260, 60);
        
        self.contentView = [[[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-15, self.frame.size.height-15)] autorelease];
        self.contentView.backgroundColor   = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.0];
        
        [self addSubview:self.contentView];
        
        [self initUI];
    }
    return self;
}

- (void)applyWithShop:(Shop *)shop
{
    self.shop = shop;
    [_titleLabel setText:shop.shop_name];
    [_timesaleLabel setText:[self getWorkhoursSale]];
}

- (void)initUI
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 240, 20)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_timesaleLabel) {
        _timesaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 28, 200, 15)];
        [_timesaleLabel setBackgroundColor:[UIColor clearColor]];
        [_timesaleLabel  setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [self.contentView addSubview:_timesaleLabel];

    }
    
    if (!_discountImageView) {
        _discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 26, 20, 20)];
        [_discountImageView setImage:[UIImage imageNamed:@"discount_icon"]];
        [self.contentView addSubview:_discountImageView];
    }

//    if (!_toDetailsBtn){
//        _toDetailsBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        CGRect frame = _toDetailsBtn.frame;
//        frame.origin.y = 10;
//        frame.origin.x = 220;
//        [_toDetailsBtn setFrame:frame];
//        [self.contentView addSubview:_toDetailsBtn];
//    }

}
- (NSString *)getWorkhoursSale
{
    if (!self.shop.workhours_sale || [self.shop.workhours_sale isEqualToString:@""]) {
        return [NSString stringWithFormat:@"暂无工时折扣"];
    }else{
        
        if ([self.shop.workhours_sale hasSuffix:@"折"]) {
            return [NSString stringWithFormat:@"工时费%@起", self.shop.workhours_sale];
        }else{
            return [NSString stringWithFormat:@"工时费%.1f折起", [self.shop.workhours_sale doubleValue]*10];
        }
        
        
//        return [NSString stringWithFormat:@"工时费%@起", self.shop.workhours_sale];
    }
}

@end
