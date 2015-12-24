//
//  TabBar.h
//  weobo
//
//  Created by mac on 15-7-22.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;
@protocol TabBarDeletgate <UITabBarDelegate>
#warning 因为TabBar继承自UITabBar，所以称为TabBar的代理，也必须实现UITabBar的代理协议
@optional
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar;

@end

@interface TabBar : UITabBar
@property (nonatomic, weak) id<TabBarDeletgate> delegate;
@end
