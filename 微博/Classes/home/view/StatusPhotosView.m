//
//  StatusPhotosView.m
//  微博
//
//  Created by mac on 15-8-8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "StatusPhotosView.h"
#import "UIView+Extension.h"
#import "StatusPhotoView.h"
#define StatusPhotoWH 70
#define StatusPhotoMargin 10
#define StatusPhotoMaxCol(count) ((count == 4)? 2: 3)
@implementation StatusPhotosView
- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    // 创建足够数量的图片控件
    NSUInteger photosCount = photos.count;
    while (self.subviews.count < photosCount) {
        StatusPhotoView * photoView = [[StatusPhotoView alloc]init];
        [self addSubview:photoView];
    }
    // 遍历所有图片控件，设置图片
    for (int i = 0; i < self.subviews.count; i++) {
        StatusPhotoView * photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        }else{// 隐藏
            photoView.hidden = YES;
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = StatusPhotoMaxCol(photosCount);
    for (int i = 0; i < photosCount; i++) {
        StatusPhotoView * photoView = self.subviews[i];
        int col = i % maxCol;
        photoView.x = col * (StatusPhotoWH + StatusPhotoMargin);
        int row = i / maxCol;
        photoView.y = row * (StatusPhotoMargin + StatusPhotoWH);
        photoView.width = StatusPhotoWH;
        photoView.height = StatusPhotoWH;
    }
}
+ (CGSize)sizeWithCount:(NSUInteger)count{
    // 最大列数
    int maxCols = StatusPhotoMaxCol(count);
    // 列数
    NSUInteger cols = (count >= maxCols) ? maxCols : count;
    CGFloat photosW = cols * StatusPhotoWH + (cols - 1) *StatusPhotoMargin;
    // 行数
    NSUInteger rows = (count + maxCols - 1 ) / maxCols;
    CGFloat photosH = rows * StatusPhotoWH + (rows - 1) *StatusPhotoMargin;
    return CGSizeMake(photosW, photosH);
}

@end
