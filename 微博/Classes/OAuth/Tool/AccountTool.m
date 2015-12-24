//
//  AccountTool.m
//  微博
//
//  Created by mac on 15-7-30.
//  Copyright (c) 2015年 mac. All rights reserved.
//
// 账号的存储路径
#define AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]
#import "AccountTool.h"

@implementation AccountTool
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(Account *)account{
    // 获得账号存储时间（accessToken的产生的时间）
    account.created_time = [NSDate date];
    
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
    
}
/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (Account *)account{
    // 加载模型
    Account * account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    /** 验证账号是否过期 */
    
    // 过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期时间
    NSDate * expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    // 获得当前时间
    NSDate * now = [NSDate date];
    
    NSComparisonResult result = [expiresTime compare:now];
    
    if (result != NSOrderedDescending) {// 过期
        return nil;
    }
    return account;
}
@end
