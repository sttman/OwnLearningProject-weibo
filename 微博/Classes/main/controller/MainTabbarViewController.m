//
//  MainTabbarViewController.m
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//
#define Color(r,g,b) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1.0]
#define RandomColor Color(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))
#import "MainTabbarViewController.h"
#import "HomeViewcontroller.h"
#import "MessageCenterViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "NavigationViewController.h"
#import "UIView+Extension.h"
#import "TabBar.h"
#import "ComposeViewController.h"
@interface MainTabbarViewController ()<TabBarDeletgate>

@end
@implementation MainTabbarViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    HomeViewcontroller * home = [[HomeViewcontroller alloc]init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    MessageCenterViewController * messageCenter = [[MessageCenterViewController alloc]init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    DiscoverViewController * discover = [[DiscoverViewController alloc]init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    ProfileViewController * profile = [[ProfileViewController alloc]init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    // 更换系统自带的tabbar
    TabBar * tabBar = [[TabBar alloc]init];
//    tabBar.delegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    //    [self setValue:[[TabBar alloc]init] forKey:@"tabBar"];这行代码过后，tabbar的delegate就是MainTabbarViewController
    // 说明，不用再蛇者tabBar.delegate = self;
    // 如果tabBar设置完delegate后，再执行修改delegate代码，就会报错
    
}
/**
 *  添加一个自控制器
 *
 *  @param childVc       自控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString*)image selectedImage:(NSString*)selectedImage{
    // 设置子控件的文字
    childVc.title = title;
    // 设置子控件的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 获得系统版本
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0) {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    // 设置文字的样式
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] =  Color(123, 123, 123);
    NSMutableDictionary * selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    // 先给外面传进来的小控制器 包装 一个导航控制器
    NavigationViewController * navc = [[NavigationViewController alloc]initWithRootViewController:childVc];
    // 添加为子控件
    [self addChildViewController:navc];
}
#pragma mark - TabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar{
    ComposeViewController * compose = [[ComposeViewController alloc]init];
    NavigationViewController * nav = [[NavigationViewController alloc]initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
