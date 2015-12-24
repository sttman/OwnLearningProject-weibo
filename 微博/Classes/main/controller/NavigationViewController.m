//
//  NavigationViewController.m
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import "NavigationViewController.h"
#import "UIBarButtonItem+Extension.h"
@interface NavigationViewController ()

@end

@implementation NavigationViewController

+ (void)initialize{
    [super initialize];
    // 设置整个项目所有item的主题样式
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    // 设置普通状态
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];;
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置不可用状态
    NSMutableDictionary * disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back{
    [self popViewControllerAnimated:YES];
}

- (void)more{
    [self popToRootViewControllerAnimated:YES];
}

@end
