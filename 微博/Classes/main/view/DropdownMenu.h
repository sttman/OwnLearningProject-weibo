//
//  DropdownMenu.h
//  weobo
//
//  Created by mac on 15-7-21.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownMenu;

@protocol DropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu;
- (void)dropdownMenuDidShow:(DropdownMenu *)menu;
@end

@interface DropdownMenu : UIView
@property (nonatomic, weak) id<DropdownMenuDelegate> delegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
