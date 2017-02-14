//
//  UIScrollView+Scale.h
//  SideMenuDemo
//
//  Created by HeHui on 15/12/28.
//  Copyright (c) 2015年 Hawie. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScaleView : UIImageView

@property (nonatomic, weak) UIScrollView *scrollView;


@end




@interface UIScrollView (Scale)


// 1. 定义一个_scaleView的成员变量
// 2. 定义了一个setter方法
// 3. 定义了一个getter方法
@property (nonatomic, weak) ScaleView *scaleView;


/** 添加可拉伸图片 */
- (ScaleView*)addScaleImageViewWithImage:(UIImage*)img;

/** 移除可拉伸图片*/
- (void)removeScaleImageView;


@end
