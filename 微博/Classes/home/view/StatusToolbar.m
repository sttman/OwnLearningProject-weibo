//
//  StatusToolbar.m
//  微博
//
//  Created by mac on 15-8-4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "StatusToolbar.h"
#import "UIView+Extension.h"
#import "Status.h"

@interface StatusToolbar ()
/** 里面存放所有的按钮*/
@property (nonatomic, strong) NSMutableArray * btns;
/** 里面存放所有的分割线*/
@property (nonatomic, strong) NSMutableArray * dividers;

@property (nonatomic, weak) UIButton * repostBtn;
@property (nonatomic, weak) UIButton * commentBtn;
@property (nonatomic, weak) UIButton * attitudeBtn;
@end
@implementation StatusToolbar
- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
- (NSMutableArray *)dividers{
    if (!_dividers) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        // 添加按钮
        self.repostBtn = [self setupBtnTitle:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtnTitle:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtnTitle:@"赞" icon:@"timeline_icon_unlike"];
        
        // 添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}
/**
 *  添加分割线
 */
- (void)setupDivider{
    UIImageView * divider = [[UIImageView alloc]init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}
/**
 *  初始化一个按钮
 *
 *  @param title 按钮文字
 *  @param icon  按钮图标
 */
- (UIButton *)setupBtnTitle:(NSString *)title icon:(NSString*)icon{
    UIButton * btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}
+ (instancetype)toolbar{
    return [[self alloc]init];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger count = self.btns.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (int i = 0; i < count; i++) {
        UIButton * btn = self.btns[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
    
    NSUInteger dividerCount = self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView * divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}
- (void)setStatus:(Status *)status{
    _status = status;
    
    
    [self setupBtnCount:status.reposts_count btn:self.repostBtn title:@"转发"];
    [self setupBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];;
    [self setupBtnCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];
}
- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title{
    if (count) {// 数字不为0
        if (count < 10000) {
        title = [NSString stringWithFormat:@"%d",count];
        }else{
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.f万",wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }// 数字为0
    [btn setTitle:title forState:UIControlStateNormal];
}
@end
