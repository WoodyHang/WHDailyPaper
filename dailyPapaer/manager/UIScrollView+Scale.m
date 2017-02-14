//
//  UIScrollView+Scale.m
//  SideMenuDemo
//
//  Created by HeHui on 15/12/28.
//  Copyright (c) 2015年 Hawie. All rights reserved.
//

#import "UIScrollView+Scale.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"

static const NSString * kScalView = @"kScallView";

static  NSString * kContentOffset = @"contentOffset";


#define Height 200

@implementation ScaleView

// setScrollView的方法


- (void)setScrollView:(UIScrollView *)scrollView
{
    
    [_scrollView removeObserver:self forKeyPath:kContentOffset];
    // 观察ScrollView的contentOffset的改变
    _scrollView = scrollView;
    // KVO
    [_scrollView addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
    
}
//

/** KVO的调用方法*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
     // 刷新当前视图的大小
    [self setNeedsLayout];
    // 注册当前视图需要刷新，在下一个消息循环的时候就会调用 layoutSubviews // NSRunLoop 
}


/** 布局子控件*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_scrollView.contentOffset.y < 0) {
        
        CGFloat offset = _scrollView.contentOffset.y;
        
        self.frame = CGRectMake(offset, offset, CGRectGetWidth(_scrollView.frame) + (-offset) * 2 , -offset + Height);
        
    }else {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame) ,  Height);
    }
}


- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:kContentOffset];
}

- (void) removeFromSuperview
{
    [_scrollView removeObserver:self forKeyPath:kContentOffset];
}




@end

@implementation UIScrollView (Scale)

// setter方法

- (void)setScaleView:(ScaleView *)scaleView
{
   // 用运行时 给UIScrollView绑定一个 属性
    
    objc_setAssociatedObject(self, &kScalView, scaleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

// getter方法

- (ScaleView *)scaleView
{
    return objc_getAssociatedObject(self, &kScalView);
}


- (ScaleView*)addScaleImageViewWithImage:(UIImage*)img{
    // 创建一个ScaleView
    ScaleView *scaleView = [[ScaleView alloc] initWithFrame:CGRectMake(0, 0 , CGRectGetWidth(self.frame), Height)];
//    scaleView.contentMode = UIViewContentModeScaleAspectFit;
//    scaleView.clipsToBounds = true;
    scaleView.image = img;
    
    scaleView.scrollView = self;
    
//    [self addSubview:scaleView];
//    [self sendSubviewToBack:scaleView];
    
    self.scaleView = scaleView;
    return scaleView;
}

- (void)removeScaleImageView
{
    [self.scaleView removeFromSuperview];
    self.scaleView = nil;
}


@end
