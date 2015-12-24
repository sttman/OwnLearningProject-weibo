//
//  EmotionAttachment.m
//  微博
//
//  Created by mac on 15-8-29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "EmotionAttachment.h"
#import "Emotion.h"
@implementation EmotionAttachment
- (void)setEmotion:(Emotion *)emotion{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
}
@end
