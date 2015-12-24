//
//  Emotion.m
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "Emotion.h"
#import "MJExtension.h"
@interface Emotion ()<NSCoding>

@end
@implementation Emotion
//MJCodingImplementation
/**
 *  从文件中解析对象时调用
 */
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.code = [decoder decodeObjectForKey:@"code"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.code forKey:@"code"];
}
/**
 *  常用来比较两个对象是否一样
 *
 *  @param other 另外一个Emotion对象
 *
 *  @return YES：代表两个对象是一样的，NO：代表两个对象是不一样
 */
- (BOOL)isEqual:(Emotion *)other{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}
@end
