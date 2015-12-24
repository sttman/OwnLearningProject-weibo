//
//  EmotionPopView.h
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion,EmotionButton;
@interface EmotionPopView : UIView
+ (instancetype)popView;

- (void)showFrom:(EmotionButton *)button;
@end
