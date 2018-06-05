//
//  GTNavigationBar.h
//  GTNavigationBar
//
//  Created by liuxc on 2018/4/27.
//

#import <UIKit/UIKit.h>

@interface GTNavigationBar : UINavigationBar

@property (nonatomic, strong, readonly) UIImageView *shadowImageView;
@property (nonatomic, strong, readonly) UIView *fakeView;
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

@end
