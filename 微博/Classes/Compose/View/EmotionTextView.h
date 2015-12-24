//
//  EmotionTextView.h
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "TextView.h"
@class Emotion;
@interface EmotionTextView : TextView
- (void)insertEmotion:(Emotion *)emotion;

- (NSString *)fullText;
@end
