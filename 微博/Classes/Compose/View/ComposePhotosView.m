//
//  ComposePhotosView.m
//  微博
//
//  Created by mac on 15-8-25.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ComposePhotosView.h"
#import "UIView+Extension.h"


@implementation ComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo{
    UIImageView *photoView = [[UIImageView alloc]init];
    photoView.image = photo;
    [self addSubview:photoView];
    
    [self.photos addObject:photo];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i < count; i++) {
        UIImageView * photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        
        int row = i / maxCol;
        photoView.y = row * (imageMargin + imageWH);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}


@end
