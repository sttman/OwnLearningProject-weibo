//
//  EmotionButton.m
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "EmotionButton.h"
#import "Emotion.h"
#import "NSString+Emoji.h"
@implementation EmotionButton
/**
 *  当控件不是从xib、storyboard中创建时，就会调用这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
/**
 *  这个方法在initWithCoder:后调用
 */
- (void)awakeFromNib{
    
}
- (void)setEmotion:(Emotion *)emotion{
    _emotion = emotion;
    if (emotion.code == nil) {// 有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    }else{// 没有图片
        // 设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}
- (void)setup{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    // 按钮高亮的时候。不要去调整图片（不要调整图片会变灰色）
    self.adjustsImageWhenHighlighted = NO;
//    self.adjustsImageWhenDisabled
}
@end
