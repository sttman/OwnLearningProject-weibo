//
//  StatusCell.h
//  微博
//
//  Created by mac on 15-8-3.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusFrame;
@interface StatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) StatusFrame * statusFrame;
@end
