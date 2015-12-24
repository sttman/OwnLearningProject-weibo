//
//  EmotionKeyboard.m
//  微博
//
//  Created by mac on 15-8-26.
//  Copyright (c) 2015年 mac. All rights reserved.
//  键盘表情：EmotionListView + EmotionTabBar

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionTabBar.h"
#import "UIView+Extension.h"
#import "Emotion.h"
#import "EmotionTool.h"
@interface EmotionKeyboard ()<EmotionTabBarDelegate>
/** 保存正在显示listView */
@property (nonatomic, weak) EmotionListView * showingListView;
/** 表情内容 */
@property (nonatomic, strong) EmotionListView * recentListView;
@property (nonatomic, strong) EmotionListView * defaultListView;
@property (nonatomic, strong) EmotionListView * emojiListView;
@property (nonatomic, strong) EmotionListView * lxhListView;
/** tabbar */
@property (nonatomic, weak) EmotionTabBar * tabBar;
@end
@implementation EmotionKeyboard
#pragma mark - 懒加载
- (EmotionListView *)recentListView{
    if (_recentListView == nil) {
        _recentListView = [[EmotionListView alloc]init];
        // 加载沙盒中的数据
        _recentListView.emotions = [EmotionTool recentEmotions];
    }
    return _recentListView;
}
- (EmotionListView *)defaultListView{
    if (_defaultListView == nil) {
        _defaultListView = [[EmotionListView alloc]init];
        _defaultListView.emotions = [EmotionTool defaultEmotions];
    }
    return _defaultListView;
}
- (EmotionListView *)emojiListView{
    if (_emojiListView == nil) {
        _emojiListView = [[EmotionListView alloc]init];
        _emojiListView.emotions = [EmotionTool emojiEmotions];
    }
    return _emojiListView;
}
- (EmotionListView *)lxhListView{
    if (_lxhListView == nil) {
        _lxhListView = [[EmotionListView alloc]init];
        _lxhListView.emotions = [EmotionTool lxhEmotions];
    }
    return _lxhListView;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.tabbar
        EmotionTabBar * tabBar = [[EmotionTabBar alloc]init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"EmotionDidSelectNotification" object:nil];
    }
    return self;
}
- (void)emotionDidSelect{
    self.recentListView.emotions = [EmotionTool recentEmotions];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    // 1.tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;

    // 2.表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
}
#pragma mark - EmotionTabBarDelegate
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType{
    // 移除contentView之前显示的控件
    [self.showingListView removeFromSuperview];
    // 根据按钮类型，切换contentView上面的listView
    switch (buttonType) {
        case EmotionTabBarButtonTypeRecent:{ // 最近
            [self addSubview:self.recentListView];
            break;
        }
            
        case EmotionTabBarButtonTypeDefault:{ // 默认
            [self addSubview:self.defaultListView];
            break;
        }
            
        case EmotionTabBarButtonTypeEmoji:{ // Emoji
            [self addSubview:self.emojiListView];
            break;
        }
            
        case EmotionTabBarButtonTypeLxh:{// Lxh
            [self addSubview:self.lxhListView];
            break;
        }
    }
    
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    // 重新计算子控件的frame（setNeedsLayout内部会在恰当的时刻，重新调用layoutSubViews，重新布局子控件）
    [self setNeedsLayout];
    
}
@end
