//
//  ComposePhotosView.h
//  微博
//
//  Created by mac on 15-8-25.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePhotosView : UIView
@property (nonatomic, strong, readonly) NSMutableArray * photos;
- (void)addPhoto:(UIImage*)photo;
@end
