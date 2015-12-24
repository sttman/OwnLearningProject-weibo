//
//  StatusFrame.h
//  微博
//
//  Created by mac on 15-8-3.
//  Copyright (c) 2015年 mac. All rights reserved.
//  一个StatusFrame模型里面包含的信息
// 1.存放着一个cell内部所有子控件的frame数据
// 2.存放一个cell的高度
// 3.存放着一个数据模型Status

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// cell之间的间距
#define StatusCellMargin 15
// 昵称字体
#define StatusCellNameFont [UIFont systemFontOfSize:15]

// 时间字体
#define StatusCellTimeFont [UIFont systemFontOfSize:12]

// 来源字体
#define StatusCellSourceFont StatusCellTimeFont

// 正文字体
#define StatusCellContentFont [UIFont systemFontOfSize:14]

// 被转发微博的正文字体
#define StatusCellRetweetContentFont [UIFont systemFontOfSize:13]

// cell的边框宽度
#define StatusCellBorderW 10
@class Status;

@interface StatusFrame : NSObject
@property (nonatomic, strong) Status * status;
/** 原创微博整体*/
@property (nonatomic,assign) CGRect originalViewF;
/** 头像*/
@property (nonatomic,assign) CGRect iconViewF;
/** 会员图标*/
@property (nonatomic,assign) CGRect vipViewF;
/** 配图*/
@property (nonatomic,assign) CGRect photoViewsF;
/** 昵称*/
@property (nonatomic,assign) CGRect nameLabelF;
/** 时间*/
@property (nonatomic,assign) CGRect timeLabelF;
/** 来源*/
@property (nonatomic,assign) CGRect sourceLabelF;
/** 正文*/
@property (nonatomic,assign) CGRect contentLabelF;

/** 转发微博整体*/
@property (nonatomic,assign) CGRect retweetViewF;
/** 转发微博正文*/
@property (nonatomic,assign) CGRect retweetContentLabelF;
/** 转发配图*/
@property (nonatomic,assign) CGRect retweetPhotosViewF;

/** 底部工具条*/
@property (nonatomic, assign) CGRect toolbarF;

/** cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;
@end
