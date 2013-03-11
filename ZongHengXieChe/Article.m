//
//  Article.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-2-23.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "Article.h"
#import "CoreService.h"

@implementation Article

- (void)dealloc
{
    [_article_id release];
    [_article_title release];
    [_article_des release];
    [_brand_logo release];
    [_brand_logo_image release];
    
    [super dealloc];
}


- (void)setBrand_logo:(NSString *)brand_logo
{
    if (_brand_logo != brand_logo) {
        if (_brand_logo) {
            [_brand_logo release];
        }
        _brand_logo = [[NSString alloc] initWithFormat:@"http://www.xieche.net/%@",brand_logo];
        
        [[CoreService sharedCoreService]loadDataWithURL:_brand_logo
                                             withParams:nil
                                    withCompletionBlock:^(id data) {
                                        self.brand_logo_image = [UIImage imageWithData:data];
                                    } withErrorBlock:nil];
    }
}


@end
