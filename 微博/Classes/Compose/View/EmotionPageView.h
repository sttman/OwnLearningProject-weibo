//
//  EmotionPageView.h
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//  用来表示一页的表情

#import <UIKit/UIKit.h>

// 一行中最多7列
#define EmotionMaxCols 7
// 一页中最多3行
#define EmotionMaxRows 3
// 每一页的表情Size
#define EmotionPageSize ((EmotionMaxRows * EmotionMaxCols) - 1)

@interface EmotionPageView : UIView
/** 这一页显示的表情 */
@property (nonatomic, strong) NSArray * emotions;
@end
