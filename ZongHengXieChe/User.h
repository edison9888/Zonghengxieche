//
//  User.h
//  ZongHengXieChe
//
//  Created by kiddz on 13-1-31.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *truename;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *prov;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *token;

@end
