//
//  HomeViewcontroller.m
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//
#import "HomeViewcontroller.h"
#import "UIBarButtonItem+Extension.h"
#import "DropdownMenu.h"
#import "TitleMenuViewController.h"
#import "Account.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "TitleButton.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "User.h"
#import "MJExtension.h"
#import "StatusCell.h"
#import "StatusFrame.h"
#import "MJRefresh.h"
#import "StatusTool.h"
@interface HomeViewcontroller ()<DropdownMenuDelegate>
/**
 *  微博数组（里面放的都是statusFrames模型，一个statusFrames对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray * statusFrames;
@end
@implementation HomeViewcontroller
- (NSMutableArray *)statusFrames{
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:211/255. green:211/255. blue:211/255. alpha:1];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获得用户信息（昵称）
    [self setupUserInfo];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];

    // 集成上拉刷新控件
    [self setupUpRefresh];
    
    // 获得未读数
//    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽出时间处理一下timer（不管主线程时候正在其他事件）
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
}
/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh{
    // 1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    
    // 2.马上加载数据
    [self.tableView headerBeginRefreshing];
}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
- (void)loadNewStatus{
    // 1.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 2.取出最前面的微博（最新的微博，ID最大的微博）
    StatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    // 定义一个block处理返回的字典数据
    void (^dealingResult)(NSArray *) = ^(NSArray *statuses){
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:statuses];
        // 将Status数组 转为uStatusFrame数组
        NSArray * newFrames = [self statusFramesWithStatuses:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        // 显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
    };
    NSArray * statuses = [StatusTool statusesWithParams:params];
    // 先尝试从数据库中加载数据
    if (statuses.count) {// 数据库有缓存数据
        dealingResult(statuses);
    }else{
        // 3.发送请求
        [HttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
            // 缓存新浪返回的字典数组
            [StatusTool saveStatuses:json[@"statuses"]];
            dealingResult(json[@"statuses"]);
        } failure:^(NSError *error) {
            // 结束刷新刷新
            [self.tableView headerEndRefreshing];
        }];
    }
}
/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus{
    // 1.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 2取出最后面的微博（最新的微博，ID最大的微博）
    StatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    // 处理字典数据
    void (^dealingResult)(NSArray *) = ^(NSArray *statuses){
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:statuses];
        // 将Status数组 转为uStatusFrame数组
        NSArray * newFrames = [self statusFramesWithStatuses:newStatuses];
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
    };
    // 加载沙盒中的数据
    NSArray * statuses = [StatusTool statusesWithParams:params];
    if (statuses.count) {
        dealingResult(statuses);
    }else{
        // 3.发送请求
        [HttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
            // 缓存新浪返回的字典数组
            [StatusTool saveStatuses:json[@"statuses"]];
            dealingResult(json[@"statuses"]);
        } failure:^(NSError *error) {
            // 结束刷新
            [self.tableView footerEndRefreshing];
        }];
    }
}
/**
 *  获得未读数
 */
- (void)setupUnreadCount{
    // 1.拼接请求参数
    Account * account = [AccountTool account];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params [@"uid"] = account.uid;
    // 2.发送请求
    [HttpTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id json) {
        // 设置提醒数字(微博的未读数)
//        NSString * status = [json[@"status"] description];
//        if ([status isEqualToString:@"0"]) {// 如果是0，得清空数字
//            self.tabBarItem.badgeValue = nil;
//            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//        } else{// 非0情况
//            self.tabBarItem.badgeValue = status;
//            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
//        }
    } failure:^(NSError *error) {
        NSLog(@"请求失败-%@",error);
    }];
}
/**
 *  将Status模型转为StatusFrame模型
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses{
    NSMutableArray * frames = [NSMutableArray array];
    for (Status * status in statuses) {
        StatusFrame *f = [[StatusFrame alloc]init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}
/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(NSUInteger)count{
    // 刷新成功(清空图标数字)
//    self.tabBarItem.badgeValue = nil;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"没有新的微博数据，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%zd条新的微博数据", count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        //        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}
/**
 *  获得用户信息（昵称）
 */
- (void)setupUserInfo{
    // 1.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2.发送请求
    [HttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        User *user = [User objectWithKeyValues:json];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = user.name;
        [AccountTool saveAccount:account];
    } failure:^(NSError *error) {
        NSLog(@"请求失败-%@", error);
    }];
}
/**
 *  设置导航栏内容
 */
- (void)setupNav{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题按钮 */
    TitleButton *titleButton = [[TitleButton alloc] init];
    // 设置图片和文字
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}
/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton{
    // 1.创建下拉菜单
    DropdownMenu *menu = [DropdownMenu menu];
    menu.delegate = self;
    
    // 2.设置内容
    TitleMenuViewController *vc = [[TitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}
- (void)friendSearch{
    NSLog(@"friendSearch");
}
- (void)pop{
    NSLog(@"pop");
}
#pragma mark - HWDropdownMenuDelegate
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;
}
/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(DropdownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusFrames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获得cell
    StatusCell *  cell = [StatusCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusFrame * frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}
@end
