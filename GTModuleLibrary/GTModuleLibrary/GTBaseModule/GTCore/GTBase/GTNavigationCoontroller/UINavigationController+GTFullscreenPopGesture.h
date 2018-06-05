//
//  UINavigationController+GTFullscreenPopGesture.h
//  GTNavigationBar
//
//  Created by liuxc on 2018/4/30.
//

#import <UIKit/UIKit.h>


/// "UINavigation+GTFullscreenPopGesture" extends UINavigationController's swipe-
/// to-pop behavior in iOS 7+ by supporting fullscreen pan gesture. Instead of
/// screen edge, you can now swipe from any place on the screen and the onboard
/// interactive pop transition works seamlessly.
///
/// Adding the implementation file of this category to your target will
/// automatically patch UINavigationController with this feature.
@interface UINavigationController (GTFullscreenPopGesture)<UINavigationControllerDelegate>

/// The gesture recognizer that actually handles interactive pop.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gt_fullscreenPopGestureRecognizer;

@property (nonatomic, assign) BOOL gt_interactiveFullScreenPopDisabled;

/// A view controller is able to control navigation bar's appearance by itself,
/// rather than a global way, checking "gt_prefersNavigationBarHidden" property.
/// Default to YES, disable it if you don't want so.
@property (nonatomic, assign) BOOL gt_viewControllerBasedNavigationBarAppearanceEnabled;

@end

