//
//  ItemTool.m
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import "ItemTool.h"

@implementation ItemTool
/**
 *  创建一个item
 *
 *  @param action    点击item后调用的方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString*)image highImage:(NSString*)highImage{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end
