//
//  TabBar.m
//  weobo
//
//  Created by mac on 15-7-22.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import "TabBar.h"
#import "UIView+Extension.h"

@interface TabBar ()
@property (nonatomic, weak) UIButton * plusBtn;
@end

@implementation TabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * plusBtn = [[UIButton alloc]init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)plusClick{
    if([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]){
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.plusBtn.centerX = self.width *.5;
    self.plusBtn.centerY = self.height * .5;
    
    CGFloat tabbarButtonW = self.width /5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView * child in self.subviews) {
                Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.width = tabbarButtonW;
            
            child.x = tabbarButtonIndex * tabbarButtonW;
            
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++;
            }
        }
    }
//    int count = self.subviews.count;
//    for (int i = 0; i<count; i++) {
//        UIView * child = self.subviews[i];
//        Class class = NSClassFromString(@"UITabBarButton");
//        if ([child isKindOfClass:class]) {
//            child.width = tabbatButtonW;
//            child.x = tabbarButtonIndex * tabbatButtonW;
//            
//            tabbarButtonIndex ++;
//            if (tabbarButtonIndex == 2) {
//                tabbarButtonIndex ++;
//            }
//        }
//    }
}

@end
