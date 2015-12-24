//
//  ProfileViewController.m
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import "ProfileViewController.h"
#import "Test1ViewController.h"
#import "SDWebImageManager.h"
@implementation ProfileViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    // 字节大小
    NSUInteger byteSize = [SDImageCache sharedImageCache].getSize;
    double size = byteSize / 1000 / 1000;
    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小(%.1fM)",size];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清除缓存" style:0 target:self action:@selector(clearCache)];
    
    [self fileOperation];
}
- (void)fileOperation{
    // 文件管理者
    NSFileManager * mgr = [NSFileManager defaultManager];
    // 缓存路径
    NSString * caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 遍历caches里面的所有内容 - 直接内容
//    NSArray * contents = [mgr contentsOfDirectoryAtPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>]
    // 遍历caches里面的所有内容 -- 直接和间接内容
    NSInteger totalByteSize = 0;
    NSArray * subPaths = [mgr subpathsAtPath:caches];
    for (NSString * subPath in subPaths) {
        // 获得全路径
        NSString * fullSubPath = [caches stringByAppendingPathComponent:subPath];
        // 判断是否为文件
        BOOL dir = NO;
        [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
        if (dir == NO) {// 文件
            totalByteSize += [[mgr attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
        }
    }
}
- (void)clearCache{
    // 提醒
    UIActivityIndicatorView * circle = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [circle startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:circle];
    // 清除缓存
    [[SDImageCache sharedImageCache] clearDisk];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清除缓存" style:0 target:self action:@selector(clearCache)];
    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小(0M)"];
}
- (void)setting{
    [self.navigationController pushViewController:[Test1ViewController new] animated:YES];
}
@end
