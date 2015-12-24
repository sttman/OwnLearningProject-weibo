//
//  NewfeatureViewController.m
//  weobo
//
//  Created by mac on 15-7-29.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import "NewfeatureViewController.h"
#import "UIView+Extension.h"
#import "MainTabbarViewController.h"
#define NewfeatureCount 4
@interface NewfeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl * pageControl;
@end

@implementation NewfeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i < NewfeatureCount
         ; i++) {
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.x = i * scrollW;
        imageView.y = 0;
        // 显示图片
        NSString * name =[NSString stringWithFormat:@"new_feature_%d",i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == NewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
#warning 默认情况下，scrollView一创建出来，它里面可能就存在一些子控件了
#warning 就算不主动添加子控件到scrollView中，scrollView内部还是可能会有一些子控件
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向上对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(NewfeatureCount *scrollW, 0);
    scrollView.pagingEnabled = YES; // 自动分页
    scrollView.bounces = NO; //去除弹簧效果
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页，展示目前看的是第几页,没有尺寸也可以显示
    UIPageControl * pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = NewfeatureCount;
    pageControl.centerX = scrollW / 2;
    pageControl.centerY = scrollH - 50;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253/255. green:98/255. blue:42/255. alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:189/255. green:189/255. blue:189/255. alpha:1];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
   // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
}

- (void)setupLastImageView:(UIImageView *)imageView{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // 1.分享给大家(checkbox)
    UIButton * shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.width = 200;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width*0.5;
    shareBtn.centerY = imageView.height*0.65;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    // EdgeInsets: 自切
    // contentEdgeInsets:会影响按钮内部的所有内容（里面的imageView和titleLabel）
    //    shareBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 100, 0, 0);
    
    // titleEdgeInsets:只影响按钮内部的titleLabel
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    // imageEdgeInsets:只影响按钮内部的imageView
    
    // 2.开始微博
    UIButton * startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.center.x;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
}
- (void)shareClick:(UIButton *)shareBtn{
    // 状态取反
    shareBtn.selected = !shareBtn.selected;
}
- (void)startClick{
    // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[MainTabbarViewController alloc]init];
    
    // modal方式，不建议采取：新特性控制器不会销毁
    //    HWTabBarViewController *main = [[HWTabBarViewController alloc] init];
    //    [self presentViewController:main animated:YES completion:nil];
}
/*
 1.程序启动会自动加载叫做Default的图片
 1> 3.5inch 非retain屏幕：Default.png
 2> 3.5inch retina屏幕：Default@2x.png
 3> 4.0inch retain屏幕: Default-568h@2x.png
 
 2.只有程序启动时自动去加载的图片, 才会自动在4inch retina时查找-568h@2x.png
 */

/*
 一个控件用肉眼看不见，有哪些可能
 1.根本没有创建实例化这个控件
 2.没有设置尺寸
 3.控件的颜色跟父控件的背景色一样（实际上已经显示了，只不过用肉眼看不见）
 4.透明度alpha <= 0.01
 5.hidden = YES
 6.没有添加到父控件中
 7.被其他控件挡住了
 8.位置不对
 9.父控件发生了以上情况
 10.特殊情况
 * UIImageView没有设置image属性，或者设置的图片名不对
 * UILabel没有设置文字，或者文字颜色和跟父控件的背景色一样
 * UITextField没有设置文字，或者没有设置边框样式borderStyle
 * UIPageControl没有设置总页数，不会显示小圆点
 * UIButton内部imageView和titleLabel的frame被篡改了，或者imageView和titleLabel没有内容
 * .....
 
 添加一个控件的建议（调试技巧）：
 1.最好设置背景色和尺寸
 2.控件的颜色尽量不要跟父控件的背景色一样
 */
@end
