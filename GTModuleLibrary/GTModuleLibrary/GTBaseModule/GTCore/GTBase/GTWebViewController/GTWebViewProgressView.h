//
//  GTWebViewProgressView.h
//  GTKit
//
//  Created by liuxc on 2018/5/10.
//  Copyright © 2018年 liuxc. All rights reserved.
//
// 网页加载进度条

#import <UIKit/UIKit.h>

@interface GTWebViewProgressView : UIView <CAAnimationDelegate>

@property (nonatomic) float progress;

@property (readonly, nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration;// default 0.5
@property (nonatomic) NSTimeInterval fadeAnimationDuration;// default 0.27

/**
 *  进度条的颜色
 */
@property (copy, nonatomic) UIColor *progressBarColor;

- (void)setProgress:(float)progress;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
