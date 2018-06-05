//
//  UIViewController+GTNavigationBar.m
//  GTNavigationBar
//
//  Created by liuxc on 2018/4/27.
//

#import "UIViewController+GTNavigationBar.h"
#import <objc/runtime.h>
#import "GTNavigationController.h"

@implementation UIViewController (GTNavigationBar)

- (UIBarStyle)gt_barStyle {
    id obj = objc_getAssociatedObject(self, _cmd);
    if (obj) {
        return [obj integerValue];
    }
    return [UINavigationBar appearance].barStyle;
}

- (void)setGt_barStyle:(UIBarStyle)gt_barStyle {
    objc_setAssociatedObject(self, @selector(gt_barStyle), @(gt_barStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)gt_barTintColor {
    UIColor *barTintColor = objc_getAssociatedObject(self, _cmd);
    return barTintColor ? barTintColor : self.navigationController.navigationBar.tintColor;
}

- (void)setGt_barTintColor:(UIColor *)tintColor {
    [self.navigationController.navigationBar setTintColor:tintColor];
    objc_setAssociatedObject(self, @selector(gt_barTintColor), tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)gt_barBackgroundColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_barBackgroundColor:(UIColor *)gt_barBackgroundColor
{
    objc_setAssociatedObject(self, @selector(gt_barBackgroundColor), gt_barBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)gt_barImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_barImage:(UIImage *)image {
    objc_setAssociatedObject(self, @selector(gt_barImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)gt_barAlpha {
    id obj = objc_getAssociatedObject(self, _cmd);
    if (self.gt_barHidden) {
        return 0;
    }
    return obj ? [obj floatValue] : 1.0f;
}

- (void)setGt_barAlpha:(float)alpha {
    objc_setAssociatedObject(self, @selector(gt_barAlpha), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gt_barHidden {
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj ? [obj boolValue] : NO;
}

- (void)setGt_barHidden:(BOOL)hidden {
    if (hidden) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        self.navigationItem.titleView = [UIView new];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.titleView = nil;
    }
    objc_setAssociatedObject(self, @selector(gt_barHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gt_barShadowHidden {
    id obj = objc_getAssociatedObject(self, _cmd);
    return  self.gt_barHidden || obj ? [obj boolValue] : NO;
}

- (void)setGt_barShadowHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(gt_barShadowHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gt_statusBarHidden {
    id obj = objc_getAssociatedObject(self, _cmd);
    return  self.gt_barHidden || obj ? [obj boolValue] : NO;
}

- (void)setGt_statusBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(gt_statusBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gt_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setGt_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(gt_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gt_interactiveFullScreenPopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setGt_interactiveFullScreenPopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(gt_interactiveFullScreenPopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gt_prefersNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setGt_prefersNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(gt_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)gt_interactivePopMaxAllowedInitialDistanceToLeftEdge {
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setGt_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance {
    SEL key = @selector(gt_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setGt_titleFont:(UIFont *)gt_titleFont
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: gt_titleFont, NSForegroundColorAttributeName: self.gt_titleColor ? self.gt_titleColor : [UIColor blackColor]}];
}

- (UIFont *)gt_titleFont
{
    return [self.navigationController.navigationBar titleTextAttributes][NSFontAttributeName];
}

- (void)setGt_titleColor:(UIColor *)gt_titleColor
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: self.gt_titleFont ? self.gt_titleFont : [UIFont systemFontOfSize:17] , NSForegroundColorAttributeName: gt_titleColor}];
}

- (UIColor *)gt_titleColor
{
    return [self.navigationController.navigationBar titleTextAttributes][NSForegroundColorAttributeName];
}

- (NSString *)gt_backItemtitle
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_backItemtitle:(NSString *)gt_backItemtitle
{
    objc_setAssociatedObject(self, @selector(gt_backItemtitle), gt_backItemtitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)gt_computedBarShadowAlpha {
    return  self.gt_barShadowHidden ? 0 : self.gt_barAlpha;
}

- (UIImage *)gt_computedBarImage {
    UIImage *image = self.gt_barImage;
    if (!image) {
        if (self.gt_barBackgroundColor) {
            return nil;
        }
        return [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
    return image;
}

- (UIColor *)gt_computedBarBackgroundColor {
    if (self.gt_barImage) {
        return nil;
    }
    UIColor *color = self.gt_barBackgroundColor;
    if (!color) {
        if ([[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault]) {
            return nil;
        }
        if ([UINavigationBar appearance].barTintColor) {
            color = [UINavigationBar appearance].barTintColor;
        } else {
            color = [UINavigationBar appearance].barStyle == UIBarStyleDefault ? [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0.8]: [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:0.729];
        }
    }
    return color;
}


- (void)gt_setNeedsUpdateNavigationBar {
    if (self.navigationController && [self.navigationController isKindOfClass:[GTNavigationController class]]) {
        GTNavigationController *nav = (GTNavigationController *)self.navigationController;
        [nav updateNavigationBarForController:self];
    }
}

-(void)gt_setNeedsUpdateNavigationBarAlpha {
    if (self.navigationController && [self.navigationController isKindOfClass:[GTNavigationController class]]) {
        GTNavigationController *nav = (GTNavigationController *)self.navigationController;
        [nav updateNavigationBarAlphaForViewController:self];
    }
}

- (void)gt_setNeedsUpdateNavigationBarColor {
    if (self.navigationController && [self.navigationController isKindOfClass:[GTNavigationController class]]) {
        GTNavigationController *nav = (GTNavigationController *)self.navigationController;
        [nav updateNavigationBarColorForViewController:self];
    }
}

- (void)gt_setNeedsUpdateNavigationBarShadowImageAlpha {
    if (self.navigationController && [self.navigationController isKindOfClass:[GTNavigationController class]]) {
        GTNavigationController *nav = (GTNavigationController *)self.navigationController;
        [nav updateNavigationBarShadowImageAlphaForViewController:self];
    }
}




@end
