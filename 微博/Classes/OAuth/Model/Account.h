//
//  Account.h
//  微博
//
//  Created by mac on 15-7-30.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>
/** string 用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString * access_token;

/** number 用于调用expires_in的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSNumber * expires_in;

/** string 当前授权用户的UID。*/
@property (nonatomic, copy) NSString * uid;

/** access token的创建时间*/
@property (nonatomic, strong) NSDate * created_time;

/** 用户的昵称 */
@property (nonatomic, copy) NSString * name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;
@end
