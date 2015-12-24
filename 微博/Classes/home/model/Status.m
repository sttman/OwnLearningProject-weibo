//
//  Status.m
//  微博
//
//  Created by mac on 15-8-2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "Status.h"
#import "MJExtension.h"
#import "Photo.h"
#import "NSDate+Extension.h"
#import <UIKit/UIKit.h>
#import "RegexKitLite.h"
#import "User.h"
#import "TextPart.h"
#import "Emotion.h"
#import "EmotionTool.h"
#import "Special.h"
@implementation Status
- (NSDictionary *)objectClassInArray{
    return @{@"pic_urls" : [Photo class]};
}

- (void)setText:(NSString *)text{
    _text = [text copy];
    
    // 利用text生成attributedText
    
    self.attributedText = [self attributedTextWithText:text];
}
/**
 *  普通文字转为属性文字
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
- (NSAttributedString *)attributedTextWithText:(NSString *)text{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[ TextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.ragne = *capturedRanges;
        [parts addObject:part];
    }];
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[ TextPart alloc] init];
        part.text = *capturedStrings;
        part.ragne = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult( TextPart *part1,  TextPart *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.ragne.location > part2.ragne.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *specials = [NSMutableArray array];
    // 按顺序拼接每一段文字
    for ( TextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isEmotion) { // 表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            NSString *name = [ EmotionTool emotionWithChs:part.text].png;
            if (name) { // 能找到对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
        } else if (part.special) { // 非表情的特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                       NSForegroundColorAttributeName : [UIColor redColor]
                                                                                       }];
            
            // 创建特殊对象
            Special *s = [[ Special alloc] init];
            s.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger len = part.text.length;
            s.ragne = NSMakeRange(loc, len);
            [specials addObject:s];
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributedText appendAttributedString:substr];
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    return attributedText;
}
- (NSString *)created_at{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate * createDate = [fmt dateFromString:_created_at];
    
    NSDate * now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差距
    NSCalendarUnit unit = NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    // 计算两个时间的差距
    NSDateComponents * cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    if ([createDate isThisYear]) {// 今年
        if ([createDate isYesterday]) {// 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]){// 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前",(int)cmps.hour];
            }else if (cmps.minute >= 1){
                return [NSString stringWithFormat:@"%d分钟前",(int)cmps.minute];
            }else{
                return @"刚刚";
            }
        }else{// 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{// 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}
- (void)setSource:(NSString *)source
{
    if (source.length){
        NSRange range;
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"</a>"].location - range.location;
        
        _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    }else{
        _source = @"来自新浪微博";
    }
}
- (void)setRetweeted_status:(Status *)retweeted_status{
    _retweeted_status = retweeted_status;
    NSString * retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status.user.name,retweeted_status.text];
    self.retweetedAttributedText = [self attributedTextWithText:retweetContent];
}
@end
