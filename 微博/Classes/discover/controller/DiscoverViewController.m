//
//  DiscoverViewController.m
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MySearchBar.h"
@implementation DiscoverViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    MySearchBar * searchBar = [[MySearchBar alloc]init];
    searchBar.width = 300;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
}
@end
