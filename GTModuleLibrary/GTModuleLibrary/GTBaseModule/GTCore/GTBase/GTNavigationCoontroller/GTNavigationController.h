//
//  GTNavigationController.h
//  GTNavigationBar
//
//  Created by liuxc on 2018/4/27.
//

#import <UIKit/UIKit.h>

@interface GTNavigationController : UINavigationController

- (void)updateNavigationBarForController:(UIViewController *)vc;
- (void)updateNavigationBarAlphaForViewController:(UIViewController *)vc;
- (void)updateNavigationBarColorForViewController:(UIViewController *)vc;
- (void)updateNavigationBarShadowImageAlphaForViewController:(UIViewController *)vc;

@end
