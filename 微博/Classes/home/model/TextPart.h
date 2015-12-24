//
//  TextPart.h
//  微博
//
//  Created by mac on 15-8-31.
//  Copyright (c) 2015年 mac. All rights reserved.
//  文字的一部分

#import <Foundation/Foundation.h>

@interface TextPart : NSObject
/** 这一段文字的内容 */
@property (nonatomic, copy) NSString * text;
/** 这一段文字的范围 */
@property (nonatomic, assign) NSRange ragne;
/** 是否为特殊文字 */
@property (nonatomic, assign ,getter=isSpecial) BOOL special;
/** 是否为特殊文字 */
@property (nonatomic, assign ,getter=isEmotion) BOOL emotion;
@end
