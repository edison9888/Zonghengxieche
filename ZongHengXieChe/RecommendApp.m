//
//  RecommendApp.m
//  ZongHengXieChe
//
//  Created by kiddz on 13-3-10.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import "RecommendApp.h"
#import "CoreService.h"

@implementation RecommendApp


- (void)dealloc
{
    [_appname release];
    [_applogo release];
    [_appdes release];
    [_url release];
    [_applogo_image release];
    
    [super dealloc];
}

- (void)setApplogo:(NSString *)applogo
{
    if (_applogo != applogo) {
        if (_applogo) {
            [_applogo release];
        }
        _applogo = applogo;
        
        [[CoreService sharedCoreService]loadDataWithURL:_applogo
                                             withParams:nil
                                    withCompletionBlock:^(id data) {
                                        self.applogo_image = [UIImage imageWithData:data];
                                    } withErrorBlock:nil];
    }
}



@end
