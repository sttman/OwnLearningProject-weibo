//
//  StatusPhotosView.h
//  微博
//
//  Created by mac on 15-8-8.
//  Copyright (c) 2015年 mac. All rights reserved.
//  cell上面的配图相册（里面会显示1~9张图）

#import <UIKit/UIKit.h>

@interface StatusPhotosView : UIView
@property (nonatomic, strong) NSArray * photos;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;
@end
