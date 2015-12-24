//
//  IconView.m
//  微博
//
//  Created by mac on 15-8-8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "IconView.h"
#import "User.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

@interface IconView ()
@property (nonatomic, weak) UIImageView * verifiedView;
@end
@implementation IconView
- (UIImageView *)verifiedView{
    if (!_verifiedView) {
        UIImageView * verifiedView = [[UIImageView alloc]init];
        [self addSubview:verifiedView];
        _verifiedView = verifiedView;
    }
    return _verifiedView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setUser:(User *)user{
    _user = user;
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    // 2.设置加V图片
    switch (user.verified_type) {
        case UserVerifiedPersonal:// 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case UserVerifiedOrgEnterprice:// 企业官方
        case UserVerifiedOrgMedia:// 媒体官方
        case UserVerifiedOrgWebsite:// 网站官方
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            self.verifiedView.hidden = NO;
            break;
        case UserVerifiedDaren:// 微博达人
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            self.verifiedView.hidden = NO;
            break;
        default:
            self.verifiedView.hidden = YES;// 当做没有任何认证
            break;
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}
@end
