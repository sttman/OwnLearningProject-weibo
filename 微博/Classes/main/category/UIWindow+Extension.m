//
//  UIWindow+Extension.m
//  微博
//
//  Created by mac on 15-7-31.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "MainTabbarViewController.h"
#import "NewfeatureViewController.h"

@implementation UIWindow (Extension)

+ (void)switchRootViewController{
    NSString * key = @"CFBundleVersion";
    // 上一次的使用版本(存储在沙盒中的版本号)
    NSString * lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号(从Info.plist中获得)
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) {// 版本号相同：这次打开和上一次打开的是同一个版本号
        window.rootViewController = [[MainTabbarViewController alloc]init];
    }else{// 这一次打开的版本号和上一次不一样，显示新特性
        window.rootViewController = [[NewfeatureViewController alloc]init];
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
