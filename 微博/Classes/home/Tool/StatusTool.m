//
//  StatusTool.m
//  微博
//
//  Created by mac on 15-9-2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "StatusTool.h"
#import "FMDB.h"
@implementation StatusTool

static FMDatabase * _db;

+ (void)initialize{
    // 1.打开数据库
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY, status blob NOT NULL, idstr text NOT NULL);"];
}
+ (NSArray *)statusesWithParams:(NSDictionary *)params{
    // 根据请求参数生成对应的查询SQL语句
    NSString * sql = nil;
    if (params[@"since_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;",params[@"since_id"]];
    }else if (params[@"max_id"]){
        sql = [NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;",params[@"max_id"]];
    }else{
        sql = @"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
    }
    // 执行SQL
    FMResultSet * set = [_db executeQuery:sql];
    NSMutableArray * statuses = [NSMutableArray array];
    while (set.next) {
        NSData * statusData = [set objectForColumnName:@"status"];
        NSDictionary * status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses addObject:status];
    }
    return statuses;
}

+ (void)saveStatuses:(NSArray *)statuses{
    // 要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary * status in statuses) {
        NSData * statusData = [NSKeyedArchiver archivedDataWithRootObject:status];
        [_db executeUpdateWithFormat:@"INSERT INTO t_status(status, idstr) VALUES (%@, %@);",statusData, status[@"idstr"]];
    }
}
@end
