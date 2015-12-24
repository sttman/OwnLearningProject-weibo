//
//  EmotionTextView.m
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "EmotionTextView.h"
#import "Emotion.h"
#import "NSString+Emoji.h"
#import "UITextView+Extension.h"
#import "EmotionAttachment.h"
@implementation EmotionTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)insertEmotion:(Emotion *)emotion{
    if (emotion.png) {
        // 加载图片
        EmotionAttachment * attch = [[EmotionAttachment alloc]init];
        // 传递模型
        attch.emotion = emotion;
        // 设置图片的尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        // 根据附件创建一个属性文字
        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }else if(emotion.code){
        // insertText: 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    }
    /*
     selectedRange
     1.本来是用来控制textView的文字范围
     2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置
     
     关于textView文字的字体
     1.如果是普通文字（text），文字大小由textView.font控制
     2.如果是属性文字（attributedText），文字大小不受textView.font控制应该利用- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
     */
}
- (NSString *)fullText{
    NSMutableString * fullText = [NSMutableString string];
    // 遍历所有的文字（图片、emoji、文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        EmotionAttachment * attch = attrs[@"NSAttachment"];
        if (attch) {// 图片
            [fullText appendString:attch.emotion.chs];
        } else {// emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString * str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
            
        }
    }];
    return fullText;
}
@end
