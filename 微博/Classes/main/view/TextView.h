//
//  TextView.h
//  微博
//
//  Created by mac on 15-8-24.
//  Copyright (c) 2015年 mac. All rights reserved.
//  增强：带有占位文字

#import <UIKit/UIKit.h>

@interface TextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString * placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor * placeholderColor;
@end
