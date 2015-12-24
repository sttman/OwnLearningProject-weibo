//
//  User.m
//  微博
//
//  Created by mac on 15-8-2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "User.h"

@implementation User
- (void)setMbtype:(int)mbtype{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end
