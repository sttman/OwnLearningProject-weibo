//
//  EmotionTool.h
//  微博
//
//  Created by mac on 15-8-29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Emotion;
@interface EmotionTool : NSObject
+ (void)addRecentEmotion:(Emotion*)emotion;
+ (NSArray *)recentEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)lxhEmotions;
+ (NSArray *)emojiEmotions;
/**
 *  通过表情描述找到对应的表情
 *
 *  @param chs 表情描述
 */
+ (Emotion *)emotionWithChs:(NSString *)chs;

@end
