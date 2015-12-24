//
//  Emotion.h
//  微博
//
//  Created by mac on 15-8-28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject
/** 表情的文件描述 */
@property (nonatomic, copy) NSString * chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString * png;
/** emoji表情的16进制编码 */
@property (nonatomic, copy) NSString * code;
@end
