//
//  Special.h
//  微博
//
//  Created by mac on 15-9-2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Special : NSObject
/** 这一段特殊文字的内容 */
@property (nonatomic, copy) NSString * text;
/** 这一段特殊文字的范围 */
@property (nonatomic, assign) NSRange ragne;
/** 这一段特殊文字的矩形框 */
@property (nonatomic, strong) NSArray * rects;
@end
