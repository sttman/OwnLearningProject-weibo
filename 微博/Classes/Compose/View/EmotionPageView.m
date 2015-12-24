//
//  EmotionPageView.m
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//  显示

#import "EmotionPageView.h"
#import "UIView+Extension.h"
#import "Emotion.h"
#import "EmotionButton.h"
#import "EmotionPopView.h"
#import "EmotionTool.h"
NSString * const EmotionDidSelectNotification = @"EmotionDidSelectNotification";
NSString * const SelectEmotionkey = @"selectEmotion";
@interface EmotionPageView ()
/** 点击表情弹出的放大镜*/
@property (nonatomic, strong) EmotionPopView * popView;
/** 删除按钮*/
@property (nonatomic, weak) UIButton * deleteButton;
@end
@implementation EmotionPageView
- (EmotionPopView *)popView{
    if (_popView == nil) {
        _popView = [EmotionPopView popView];
    }
    return _popView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.删除按钮
        UIButton * deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        // 2.添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}
/**
 *  根据手指的位置所在的表情按钮
 */
- (EmotionButton *)emotionButtonWithLocation:(CGPoint)locaiont{
    // 获得手指所在的位置
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        EmotionButton * btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, locaiont)) {
            // 已经找到手指所在的表情按钮了，就没有必要在往下遍历
            // 显示popView
            return btn;
        }
    }
    return nil;
}
/**
 *  在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer* )recognizer{
    
    // 获得手指所在的位置
    CGPoint locaiont = [recognizer locationInView:recognizer.view];
    EmotionButton * btn = [self emotionButtonWithLocation:locaiont];
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:// 手指已经不再触摸pageView
            // 移除popView
            [self.popView removeFromSuperview];
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan:// 手势开始
        case UIGestureRecognizerStateChanged:// 手指的位置改变
            [self.popView showFrom:btn];
            break;
    }
}
- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        EmotionButton * btn = [[EmotionButton alloc]init];
        [self addSubview:btn];
        // 设置表情数据
        btn.emotion = emotions[i];
        // 监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 内边距
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / EmotionMaxCols;
    CGFloat btnH = (self.height - inset) / EmotionMaxRows;
    for (int i = 0; i < count; i++) {
        UIButton * btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i % EmotionMaxCols) * btnW;
        btn.y = inset + (i / EmotionMaxCols) * btnH;
    }
    
    // 删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - inset - btnW;
}
/**
 *  监听删除按钮
 */
- (void)deleteClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionDidDeleteNotification" object:nil];
}
/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
- (void)btnClick:(EmotionButton *)btn{
    // 显示popView
    [self.popView showFrom:btn];
    
    // 等会让popView自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知
    [self selectEmotion:btn.emotion];
}
/**
 *  选中某个表情，发出通知
 *
 *  @param emotion 被选中的表情
 */
- (void)selectEmotion:(Emotion *)emotion{
    // 将这个表情存入沙盒
    [EmotionTool addRecentEmotion:emotion];
    // 发出通知
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    userInfo[SelectEmotionkey] = emotion;
    [[NSNotificationCenter defaultCenter]postNotificationName:EmotionDidSelectNotification object:nil userInfo:userInfo];
}
@end
