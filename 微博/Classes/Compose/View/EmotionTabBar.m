//
//  EmotionTabBar.m
//  微博
//
//  Created by mac on 15-8-26.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "EmotionTabBar.h"
#import "UIView+Extension.h"
#import "EmotionTabBarButton.h"

@interface EmotionTabBar ()
@property (nonatomic, weak) EmotionTabBarButton * selectedBtn;
@end
@implementation EmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:EmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:EmotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:EmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:EmotionTabBarButtonTypeLxh];
    }
    return self;
}
/**
 *  创建一个按钮
 *
 *  @param title 按钮文字
 */
- (void)setupBtn:(NSString *)title buttonType:(EmotionTabBarButtonType)buttonType{
    // 创建按钮
    EmotionTabBarButton * btn = [[EmotionTabBarButton alloc]init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    
    // 设置背景图片
    NSString * image = @"compose_emotion_table_mid_normal";
    NSString * selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (int i = 0; i < count; i++) {
        UIButton * btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}
- (void)setDelegate:(id<EmotionTabBarDelegate>)delegate{
    _delegate = delegate;
    // 选中“默认”按钮
    [self btnClick:(EmotionTabBarButton*)[self viewWithTag:EmotionTabBarButtonTypeDefault]];
}
/**
 *  按钮点击
 */
- (void)btnClick:(EmotionTabBarButton *)btn{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:btn.tag];
    }
}
@end
