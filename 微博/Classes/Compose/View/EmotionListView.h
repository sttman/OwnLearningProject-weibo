//
//  EmotionListView.h
//  微博
//
//  Created by mac on 15-8-26.
//  Copyright (c) 2015年 mac. All rights reserved.
//  表情键盘顶部的表情内容：scrol + pageControl

#import <UIKit/UIKit.h>

@interface EmotionListView : UIView
/** 表情(里面存放的是Emotion模型) */
@property (nonatomic, strong) NSArray * emotions;
@end
