//
//  YTKAnimatingRequestAccessory.m
//  Ape_uni
//
//  Created by Chenyu Lan on 10/30/14.
//  Copyright (c) 2014 Fenbi. All rights reserved.
//

#import "YTKAnimatingRequestAccessory.h"
//#import "YTKAlertUtils.h"
#import "GTProgressHUD.h"

@implementation YTKAnimatingRequestAccessory

- (id)initWithAnimatingView:(UIView *)animatingView animatingText:(NSString *)animatingText {
    self = [super init];
    if (self) {
        _animatingView = animatingView;
        _animatingText = animatingText;
    }
    return self;
}

- (id)initWithAnimatingView:(UIView *)animatingView {
    self = [super init];
    if (self) {
        _animatingView = animatingView;
    }
    return self;
}

+ (id)accessoryWithAnimatingView:(UIView *)animatingView {
    return [[self alloc] initWithAnimatingView:animatingView];
}

+ (id)accessoryWithAnimatingView:(UIView *)animatingView animatingText:(NSString *)animatingText {
    return [[self alloc] initWithAnimatingView:animatingView animatingText:animatingText];
}

- (void)requestWillStart:(id)request {
    if (_animatingView) {
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(wself) strongSelf = wself;
            // TODO: show loading
            NSLog(@" loading start");
            [GTProgressHUD showLoading:strongSelf->_animatingText view:strongSelf->_animatingView];
        });
    }
}

- (void)requestWillStop:(id)request {
    if (_animatingView) {
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(wself) strongSelf = wself;
            // TODO: hide loading
            NSLog(@" loading finished");
            [GTProgressHUD hideHUDForView:strongSelf->_animatingView animated:YES];
        });
    }
}

@end
