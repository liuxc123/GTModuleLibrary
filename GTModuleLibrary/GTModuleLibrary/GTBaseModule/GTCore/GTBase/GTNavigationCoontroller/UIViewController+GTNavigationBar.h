//
//  UIViewController+GTNavigationBar.h
//  GTNavigationBar
//
//  Created by liuxc on 2018/4/27.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GTNavigationBar)
//naviBar
@property (nonatomic, assign) UIBarStyle gt_barStyle;
@property (nonatomic, strong) UIColor *gt_barBackgroundColor;
@property (nonatomic, strong) UIColor *gt_barTintColor;
@property (nonatomic, strong) UIImage *gt_barImage;
@property (nonatomic, assign) float gt_barAlpha;
@property (nonatomic, assign) BOOL gt_barHidden;
@property (nonatomic, assign) BOOL gt_prefersNavigationBarHidden;
@property (nonatomic, assign) BOOL gt_barShadowHidden;
@property (nonatomic, assign) BOOL gt_statusBarHidden;

// computed
@property (nonatomic, assign, readonly) float gt_computedBarShadowAlpha;
@property (nonatomic, strong, readonly) UIColor *gt_computedBarBackgroundColor;
@property (nonatomic, strong, readonly) UIImage *gt_computedBarImage;

@property (nonatomic, assign) BOOL gt_interactivePopDisabled;
@property (nonatomic, assign) BOOL gt_interactiveFullScreenPopDisabled;
@property (nonatomic, assign) CGFloat gt_interactivePopMaxAllowedInitialDistanceToLeftEdge;

// title
@property (nonatomic, strong) UIColor *gt_titleColor;
@property (nonatomic, strong) UIFont *gt_titleFont;

@property (nonatomic, strong) NSString *gt_backItemtitle;

- (void)gt_setNeedsUpdateNavigationBar;
- (void)gt_setNeedsUpdateNavigationBarAlpha;
- (void)gt_setNeedsUpdateNavigationBarColor;
- (void)gt_setNeedsUpdateNavigationBarShadowImageAlpha;

@end
