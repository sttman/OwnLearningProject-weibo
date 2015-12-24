//
//  EmotionListView.m
//  微博
//
//  Created by mac on 15-8-26.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "EmotionListView.h"
#import "UIView+Extension.h"
#import "EmotionPageView.h"
@interface EmotionListView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, weak) UIPageControl * pageControl;
@end
@implementation EmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 1.UIScrollerView
        UIScrollView * scrollView = [[UIScrollView alloc]init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        // 取消水平方向上的滚动条
        scrollView.showsHorizontalScrollIndicator = NO;
        // 去除竖直方向的滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.pageControl
        UIPageControl * pageControl = [[UIPageControl alloc]init];
        // 当只有一页时，自动影藏pageControl
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        // 设置内部的原点图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

// 根据emotion，创建对应个数的表情
- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    // 删除之前的控件
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + EmotionPageSize - 1) / EmotionPageSize;
    
    // 1.设置页数
    self.pageControl.numberOfPages = count;
    
    // 2.创建用来显示每一页表情的控件
    for (int i = 0; i<count; i++) {
        EmotionPageView *pageView = [[EmotionPageView alloc] init];
        // 计算这一页的表情范围
        NSRange range;
        range.location = i * EmotionPageSize;
        // left：剩余的表情个数（可以截取的）
        NSUInteger left = emotions.count - range.location;
        if (left >= EmotionPageSize) { // 这一页足够20个
            range.length = EmotionPageSize;
        } else {
            range.length = left;
        }
        // 设置这一页的表情
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 1.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2.scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    // 3.设置scrollView内部每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i <count; i++) {
        EmotionPageView * pageView = self.scrollView.subviews[i];
        pageView.width = self.scrollView.width;
        pageView.height = self.scrollView.height;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    // 4.设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double pageNO = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNO + 0.5);
}
@end
