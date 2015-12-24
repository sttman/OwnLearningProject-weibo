//
//  StatusToolbar.h
//  微博
//
//  Created by mac on 15-8-4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;
@interface StatusToolbar : UIView
+ (instancetype)toolbar;
@property (nonatomic, strong) Status * status;
@end
