//
//  UIScrollView+GTFullscreenPopGesture.m
//  GTNavigationBar
//
//  Created by liuxc on 2018/4/30.
//

#import "UIScrollView+GTFullscreenPopGesture.h"

@implementation UIScrollView (GTFullscreenPopGesture)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_GTFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
