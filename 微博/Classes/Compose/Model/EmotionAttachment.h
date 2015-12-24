//
//  EmotionAttachment.h
//  微博
//
//  Created by mac on 15-8-29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;
@interface EmotionAttachment : NSTextAttachment
@property (nonatomic, strong) Emotion * emotion;
@end
