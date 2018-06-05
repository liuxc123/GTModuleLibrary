//
//  GTBaseViewController.h
//  GTKit
//
//  Created by liuxc on 2018/3/24.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RealReachability/RealReachability.h>
#import "UIViewController+GTNavigationBar.h"
#import "UIView+GTTransition.h"
#import "GTProgressHUD.h"
//#import "GTLoadingView.h"

@interface GTBaseViewController : UIViewController

#pragma mark - 属性

/**
 修改当前界面要支持的横竖屏方向，默认为 UIInterfaceOrientationMaskAll
 */
@property(nonatomic, assign) UIInterfaceOrientationMask supportedOrientationMask;

/**
 loading加载页面，空数据页面(如果重置位置样式， 请重写get方法)
 */
//@property(nonatomic, assign) GTLoadingView *loadingView;


#pragma mark - 自定义转场动画

/*！
 自定义动画样式
 
 @param type 动画样式
 @param animationView 需要动画的 View
 */
//- (void)gt_animationWithGTTransitionType:(GTViewTransitionType)type
//                           animationView:(UIView *)animationView;

#pragma mark - 清理缓存


@end

@interface GTBaseViewController(SubClassHooks)

#pragma mark - 自定义方法

/**
 配置导航栏
 */
- (void)configNavi;

/**
 配置主题
 */
- (void)configTheme;

/**
 content字体大小变化通知方法
 */
- (void)contentSizeCategoryDidChanged:(NSNotification *)notification;


/**
 重新布局LoadingView
 */
- (void)layoutLoadingView;

@end
