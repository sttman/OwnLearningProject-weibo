//
//  EmotionTool.m
//  微博
//
//  Created by mac on 15-8-29.
//  Copyright (c) 2015年 mac. All rights reserved.
//  最近表情的存储路径
#define RecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "EmotionTool.h"
#import "MJExtension.h"
#import "Emotion.h"

@implementation EmotionTool
static NSMutableArray * _recentEmotios;

+ (void)initialize{
    _recentEmotios = [NSKeyedUnarchiver unarchiveObjectWithFile:RecentEmotionsPath];
    if (_recentEmotios == nil) {
        _recentEmotios = [NSMutableArray array];
    }
}
static NSArray * _emojiEmotions, *_defaultEmotions, *_lxhEmotions;
+ (NSArray *)emojiEmotions{
    if (!_emojiEmotions) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}
+ (NSArray *)defaultEmotions{
    if (!_defaultEmotions) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}
+ (NSArray *)lxhEmotions{
    if (!_lxhEmotions) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}
+ (Emotion *)emotionWithChs:(NSString *)chs{
    NSArray * defaults = [self defaultEmotions];
    for (Emotion * emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    NSArray * lxhs = [self lxhEmotions];
    for (Emotion * emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    return nil;
}
+ (void)addRecentEmotion:(Emotion *)emotion{
    
    // 删除重复的表情
    [_recentEmotios removeObject:emotion];
    
    // 将表情放到数组的最前面
    [_recentEmotios insertObject:emotion atIndex:0];
    
    // 将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotios toFile:RecentEmotionsPath];
}
/**
 *  返回装着Emotion模型的数组
 */
+ (NSArray *)recentEmotions{
    return _recentEmotios;
}
// 加载沙盒中的表情数据
//    NSMutableArray * emotions = (NSMutableArray*)[self recentEmotions];
//    if (emotions == nil) {
//        emotions = [NSMutableArray array];
//    }

//    for (int i = 0; i < emotions.count; i++) {
//        Emotion * e = emotions[i];
//        if ([e.chs isEqualToString:emotion.chs]|| [e.code isEqualToString:emotion.code]) {
//            [emotions removeObject:e];
//            break;
//        }
//    }

//    for (Emotion *e in emotions) {
//        [emotions removeObject:e];
//        break;
//    }
@end
