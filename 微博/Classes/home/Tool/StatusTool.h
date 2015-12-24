//
//  StatusTool.h
//  微博
//
//  Created by mac on 15-9-2.
//  Copyright (c) 2015年 mac. All rights reserved.
//  微博工具类:用来处理微博数据的缓存

#import <Foundation/Foundation.h>

@interface StatusTool : NSObject
/**
 *  根据请求参数去沙盒中加载缓存的微博数据
 *
 *  @param params 请求参数
 */
+ (NSArray *)statusesWithParams:(NSDictionary *)params;
/**
 *  存储微博数据到沙盒中
 *
 *  @param statuses 需要存储的微博数据
 */
+ (void)saveStatuses:(NSArray *)statuses;
@end
