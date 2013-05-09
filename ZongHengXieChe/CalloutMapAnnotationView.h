//
//  CalloutMapAnnotationView.h
//  ZongHengXieChe
//
//  Created by Kiddz on 13-4-18.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKAnnotationView.h"
#import "Shop.h"

@interface CalloutMapAnnotationView : BMKAnnotationView

@property(nonatomic,retain) UIView *contentView;
@property(nonatomic,retain) Shop   *shop;

- (void)applyWithShop:(Shop *)shop;
@end
