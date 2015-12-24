//
//  ItemTool.h
//  weobo
//
//  Created by mac on 15-7-9.
//  Copyright (c) 2015年 IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Extension.h"
@interface ItemTool : NSObject
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString*)image highImage:(NSString*)highImage;
@end
