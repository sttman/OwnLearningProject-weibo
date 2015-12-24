//
//  StatusTextView.h
//  微博
//
//  Created by mac on 15-9-1.
//  Copyright (c) 2015年 mac. All rights reserved.
//  用来显示微博正文的

#import <UIKit/UIKit.h>

@interface StatusTextView : UITextView
/** 所有的特殊字符串 */
@property (nonatomic, strong) NSArray * specials;
@end
