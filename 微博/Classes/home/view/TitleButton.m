//
//  TitleButton.m
//  微博
//
//  Created by mac on 15-7-31.
//  Copyright (c) 2015年 mac. All rights reserved.
//
#define Margin 10
#import "TitleButton.h"
#import "UIView+Extension.h"
@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}
// 目的：想在系统计算和设置完按钮的尺寸后，再修改一下尺寸
/**
 *  重写setFrame:的方法目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸后，在做修改，而且要保证修改成功，一般都是在setFrame:设置
 */
- (void)setFrame:(CGRect)frame{
    frame.size.width += Margin;
    [super setFrame:frame];
}
- (void)layoutSubviews{
    [super layoutSubviews];
     // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    
    // 1.计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    // 2.计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 10;
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}
@end
