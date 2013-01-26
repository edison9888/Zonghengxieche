//
//  BaseViewController.h
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface BaseViewController : UIViewController


@property (nonatomic, retain) UIImageView *titleImage;

- (void)changeTitleView;
- (void)loadHttpURL:(NSString *)urlString withParams:(NSMutableDictionary *)dic withCompletionBlock:(void (^)(id data))completionHandler withErrorBlock:(void (^)(NSError *error))errorHandler;

- (NSMutableArray *)convertXml2Obj:(NSString *)xmlString withClass:(Class)clazz;
@end