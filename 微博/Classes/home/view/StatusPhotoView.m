//
//  StatusPhoto.m
//  微博
//
//  Created by mac on 15-8-8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "StatusPhotoView.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
@interface StatusPhotoView ()
@property (nonatomic, weak) UIImageView *gifView;
@end
@implementation StatusPhotoView
- (UIImageView *)gifView{
    if (!_gifView) {
        UIImage * image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView * gifView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    return _gifView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
         1.凡是带有scale单词的，图片都会拉伸
         2.凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形
         */
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(Photo *)photo{
    _photo = photo;
    // 设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    // 显示\隐藏gif控件
    // 判断是否以gif或者GIF结尾
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}
@end
