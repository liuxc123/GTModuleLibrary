//
//  GTNavigationController.m
//  GTNavigationBar
//
//  Created by liuxc on 2018/4/27.
//

#import "GTNavigationController.h"
#import "GTNavigationBar.h"
#import "UIViewController+GTNavigationBar.h"

@interface GTNavigationController ()< UINavigationControllerDelegate>

@property (nonatomic, readonly) GTNavigationBar *navigationBar;
@property (nonatomic, strong) UIVisualEffectView *fromFakeBar;
@property (nonatomic, strong) UIVisualEffectView *toFakeBar;
@property (nonatomic, strong) UIImageView *fromFakeShadow;
@property (nonatomic, strong) UIImageView *toFakeShadow;
@property (nonatomic, strong) UIImageView *fromFakeImageView;
@property (nonatomic, strong) UIImageView *toFakeImageView;

@end

@implementation GTNavigationController

@dynamic navigationBar;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithNavigationBarClass:[GTNavigationBar class] toolbarClass:nil]) {
        self.viewControllers = @[ rootViewController ];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    NSAssert([navigationBarClass isSubclassOfClass:[GTNavigationBar class]], @"navigationBarClass Must be a subclass of GTNavigationBar");
    return [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
}

- (instancetype)init {
    return [super initWithNavigationBarClass:[GTNavigationBar class] toolbarClass:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
    [self.navigationBar setTranslucent:YES]; // make sure translucent
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {

    UIViewController * viewController = self.viewControllers.count > 1 ? \
    [self.viewControllers objectAtIndex:self.viewControllers.count - 2] : nil;

    if (!viewController) {
        return YES;
    }

    NSString *backButtonTitle = nil;
    if (viewController.gt_backItemtitle != nil) {
        backButtonTitle = viewController.gt_backItemtitle;
    }

    if (!backButtonTitle) {
        backButtonTitle = viewController.title;
    }

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil action:nil];
    viewController.navigationItem.backBarButtonItem = backButtonItem;

    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationBar.barStyle = viewController.gt_barStyle;
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.transitionCoordinator;
    UIViewController *from = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //设置状态栏显示隐藏
    if (from.gt_statusBarHidden || to.gt_statusBarHidden) {
        [self setNavigationBarHidden:viewController.gt_prefersNavigationBarHidden animated:YES];
    }
    
    //控制导航条的显示隐藏
    if (from.gt_prefersNavigationBarHidden || to.gt_prefersNavigationBarHidden) {
        [self setNavigationBarHidden:viewController.gt_prefersNavigationBarHidden animated:YES];
        return;
    }
    
    //控制导航条的平滑过渡
    if (coordinator) {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (shouldShowFake(viewController, from, to)) {
                [UIView performWithoutAnimation:^{
                    self.navigationBar.fakeView.alpha = 0;
                    self.navigationBar.shadowImageView.alpha = 0;
                    self.navigationBar.backgroundImageView.alpha = 0;
                    
                    // from
                    self.fromFakeImageView.image = from.gt_computedBarImage;
                    self.fromFakeImageView.alpha = from.gt_barAlpha;
                    self.fromFakeImageView.frame = [self fakeBarFrameForViewController:from];
                    [from.view addSubview:self.fromFakeImageView];
                    self.fromFakeBar.subviews[1].backgroundColor = from.gt_computedBarBackgroundColor;
                    self.fromFakeBar.alpha = from.gt_barAlpha == 0 || from.gt_computedBarImage ? 0.01:from.gt_barAlpha;
                    if (from.gt_barAlpha == 0 || from.gt_computedBarImage) {
                        self.fromFakeBar.subviews[1].alpha = 0.01;
                    }
                    self.fromFakeBar.frame = [self fakeBarFrameForViewController:from];
                    [from.view addSubview:self.fromFakeBar];
                    
                    self.fromFakeShadow.alpha = from.gt_computedBarShadowAlpha;
                    self.fromFakeShadow.frame = [self fakeShadowFrameWithBarFrame:self.fromFakeBar.frame];
                    [from.view addSubview:self.fromFakeShadow];
                    
                    // to
                    self.toFakeImageView.image = to.gt_computedBarImage;
                    self.toFakeImageView.alpha = to.gt_barAlpha;
                    self.toFakeImageView.frame = [self fakeBarFrameForViewController:to];
                    [to.view addSubview:self.toFakeImageView];
                    self.toFakeBar.subviews[1].backgroundColor = to.gt_computedBarBackgroundColor;
                    self.toFakeBar.alpha = to.gt_computedBarImage ? 0 : to.gt_barAlpha;
                    self.toFakeBar.frame = [self fakeBarFrameForViewController:to];
                    [to.view addSubview:self.toFakeBar];
                    self.toFakeShadow.alpha = to.gt_computedBarShadowAlpha;
                    self.toFakeShadow.frame = [self fakeShadowFrameWithBarFrame:self.toFakeBar.frame];
                    [to.view addSubview:self.toFakeShadow];
                }];
            } else {
                [self updateNavigationBarForController:viewController];
            }
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (context.isCancelled) {
                [self updateNavigationBarForController:from];
            } else {
                // 当 present 时 to 不等于 viewController
                [self updateNavigationBarForController:viewController];
            }
            if (to == viewController) {
                [self clearFake];
            }
        }];
    } else {
        [self updateNavigationBarForController:viewController];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [super popViewControllerAnimated:animated];
    self.navigationBar.barStyle = self.topViewController.gt_barStyle;
    return vc;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *array = [super popToViewController:viewController animated:animated];
    self.navigationBar.barStyle = self.topViewController.gt_barStyle;
    return array;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *array = [super popToRootViewControllerAnimated:animated];
    self.navigationBar.barStyle = self.topViewController.gt_barStyle;
    return array;
}

- (UIVisualEffectView *)fromFakeBar {
    if (!_fromFakeBar) {
        _fromFakeBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    return _fromFakeBar;
}

- (UIVisualEffectView *)toFakeBar {
    if (!_toFakeBar) {
        _toFakeBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    return _toFakeBar;
}

- (UIImageView *)fromFakeImageView {
    if (!_fromFakeImageView) {
        _fromFakeImageView = [[UIImageView alloc] init];
    }
    return _fromFakeImageView;
}

- (UIImageView *)toFakeImageView {
    if (!_toFakeImageView) {
        _toFakeImageView = [[UIImageView alloc] init];
    }
    return _toFakeImageView;
}

- (UIImageView *)fromFakeShadow {
    if (!_fromFakeShadow) {
        _fromFakeShadow = [[UIImageView alloc] initWithImage:self.navigationBar.shadowImageView.image];
        _fromFakeShadow.backgroundColor = self.navigationBar.shadowImageView.backgroundColor;
    }
    return _fromFakeShadow;
}

- (UIImageView *)toFakeShadow {
    if (!_toFakeShadow) {
        _toFakeShadow = [[UIImageView alloc] initWithImage:self.navigationBar.shadowImageView.image];
        _toFakeShadow.backgroundColor = self.navigationBar.shadowImageView.backgroundColor;
    }
    return _toFakeShadow;
}

- (void)clearFake {
    [self.fromFakeBar removeFromSuperview];
    [self.toFakeBar removeFromSuperview];
    [self.fromFakeShadow removeFromSuperview];
    [self.toFakeShadow removeFromSuperview];
    [self.fromFakeImageView removeFromSuperview];
    [self.toFakeImageView removeFromSuperview];
    self.fromFakeBar = nil;
    self.toFakeBar = nil;
    self.fromFakeShadow = nil;
    self.toFakeShadow = nil;
    self.fromFakeImageView = nil;
    self.toFakeImageView = nil;
}

BOOL shouldShowFake(UIViewController *vc,UIViewController *from, UIViewController *to) {
    if (vc != to ) {
        return NO;
    }
    
    if (from.gt_computedBarImage && to.gt_computedBarImage && isImageEqual(from.gt_computedBarImage, to.gt_computedBarImage)) {
        // 都有图片，并且是同一张图片
        if (ABS(from.gt_barAlpha - to.gt_barAlpha) > 0.1) {
            return YES;
        }
        return NO;
    }
    
    if (!from.gt_computedBarImage && !to.gt_computedBarImage && [from.gt_computedBarBackgroundColor.description isEqual:to.gt_computedBarBackgroundColor.description]) {
        // 都没图片，并且颜色相同
        if (ABS(from.gt_barAlpha - to.gt_barAlpha) > 0.1) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

BOOL isImageEqual(UIImage *image1, UIImage *image2) {
    if (image1 == image2) {
        return YES;
    }
    if (image1 && image2) {
        NSData *data1 = UIImagePNGRepresentation(image1);
        NSData *data2 = UIImagePNGRepresentation(image2);
        BOOL result = [data1 isEqual:data2];
        return result;
    }
    return NO;
}

- (CGRect)fakeBarFrameForViewController:(UIViewController *)vc {
    UIView *back = self.navigationBar.subviews[0];
    CGRect frame = [self.navigationBar convertRect:back.frame toView:vc.view];
    frame.origin.x = vc.view.frame.origin.x;
    return frame;
}

- (CGRect)fakeShadowFrameWithBarFrame:(CGRect)frame {
    return CGRectMake(frame.origin.x, frame.size.height + frame.origin.y, frame.size.width, 0.5);
}

- (void)updateNavigationBarForController:(UIViewController *)vc {
    [self updateNavigationBarAlphaForViewController:vc];
    [self updateNavigationBarColorForViewController:vc];
    [self updateNavigationBarShadowImageAlphaForViewController:vc];
    self.navigationBar.barStyle = vc.gt_barStyle;
}

- (void)updateNavigationBarAlphaForViewController:(UIViewController *)vc {
    if (vc.gt_computedBarImage) {
        self.navigationBar.fakeView.alpha = 0;
        self.navigationBar.backgroundImageView.alpha = vc.gt_barAlpha;
    } else {
        self.navigationBar.fakeView.alpha = vc.gt_barAlpha;
        self.navigationBar.backgroundImageView.alpha = 0;
    }
    self.navigationBar.shadowImageView.alpha = vc.gt_computedBarShadowAlpha;
}

- (void)updateNavigationBarColorForViewController:(UIViewController *)vc {
    self.navigationBar.barTintColor = vc.gt_computedBarBackgroundColor;
    self.navigationBar.backgroundImageView.image = vc.gt_computedBarImage;
}

- (void)updateNavigationBarShadowImageAlphaForViewController:(UIViewController *)vc {
    self.navigationBar.shadowImageView.alpha = vc.gt_computedBarShadowAlpha;
}

/**
 *  导航控制器 统一管理状态栏颜色
 *  @return 状态栏颜色
 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.topViewController preferredStatusBarStyle];
}

/*!

 iOS加载启动图的时候隐藏statusbar

 只需需要在info.plist中加入Status bar is initially hidden 设置为YES就好
 */


@end
