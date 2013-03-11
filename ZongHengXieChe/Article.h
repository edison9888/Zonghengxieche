//
//  Article.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-23.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *article_title;
@property (nonatomic, copy) NSString *article_des;
@property (nonatomic, copy) NSString *brand_logo;
@property (nonatomic, copy) UIImage  *brand_logo_image;

@end
