//
//  EmotionTabBar.h
//  微博
//
//  Created by mac on 15-8-26.
//  Copyright (c) 2015年 mac. All rights reserved.
//  表情键盘底部的选项卡

#import <UIKit/UIKit.h>

typedef enum {
    EmotionTabBarButtonTypeRecent, // 最近
    EmotionTabBarButtonTypeDefault, // 默认
    EmotionTabBarButtonTypeEmoji, // emoji
    EmotionTabBarButtonTypeLxh, // 浪小花
}EmotionTabBarButtonType;
@class EmotionTabBar;
@protocol EmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType;

@end
@interface EmotionTabBar : UIView
@property (nonatomic, weak) id<EmotionTabBarDelegate> delegate;
@end
