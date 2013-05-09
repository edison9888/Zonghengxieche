//
//  Constants.h
//  4S
//
//  Created by kiddz on 13-1-22.
//  Copyright (c) 2013年 kiddz. All rights reserved.
//

#import <Foundation/Foundation.h>
#if defined(__cplusplus)
#define ZH_EXTERN extern "C"
#else
#define ZH_EXTERN extern
#endif

#define ENVIRONMENT_DEVELOPMENT

ZH_EXTERN NSString *const IsFirstLaunchKey;

ZH_EXTERN NSString *const NotRecallTabbar;

ZH_EXTERN NSString *const UserIdKey;
ZH_EXTERN NSString *const UserNameKey;
ZH_EXTERN NSString *const UserEmailKey;
ZH_EXTERN NSString *const UserMobileKey;
ZH_EXTERN NSString *const UserPasswordKey;
ZH_EXTERN NSString *const UserTokenKey;
ZH_EXTERN NSString *const UserTruenameKey;
ZH_EXTERN NSString *const UserProvKey;
ZH_EXTERN NSString *const UserCityKey;
ZH_EXTERN NSString *const UserAreaKey;
ZH_EXTERN NSString *const LastLoginNameKey;



ZH_EXTERN NSString *const CityIdKey;
ZH_EXTERN NSString *const CityNameKey;

ZH_EXTERN NSString *const LastLoginTimeKey;

@interface Constants : NSObject



@end
