//
//  User.h
//  微博
//
//  Created by mac on 15-8-2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    UserVerifiedTypeNone = -1,// 没有任何认证
    UserVerifiedPersonal = 0, // 个人认证
    UserVerifiedOrgEnterprice = 2, // 企业官方：
    UserVerifiedOrgMedia = 3,// 媒体官方
    UserVerifiedOrgWebsite = 5,// 网站官方
    UserVerifiedDaren = 220,// 微博达人
}UserVerifiedType;
@interface User : NSObject
/** string 字符串的用户UID*/
@property (nonatomic, copy) NSString * idstr;

/** string 好友显示名称*/
@property (nonatomic, copy) NSString * name;

/** string 用户头像地址，50x50像素*/
@property (nonatomic, strong) NSString * profile_image_url;

/** 会员类型 值 > 2，才代表是会员*/
@property (nonatomic, assign) int mbtype;

/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter=isVip) BOOL vip;

/** 认证类型*/
@property (nonatomic, assign) UserVerifiedType verified_type;
@end
