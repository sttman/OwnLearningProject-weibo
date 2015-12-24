//
//  AccountTool.h
//  微博
//
//  Created by mac on 15-7-30.
//  Copyright (c) 2015年 mac. All rights reserved.
//  处理账号相关的所有操作:存储账号、取出账号、验证账号

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(Account *)account;
/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (Account *)account;
@end
