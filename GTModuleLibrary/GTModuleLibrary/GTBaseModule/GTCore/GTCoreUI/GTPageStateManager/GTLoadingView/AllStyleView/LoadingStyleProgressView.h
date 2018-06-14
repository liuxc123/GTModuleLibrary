//
//  LoadingStyleProgressView.h
//  GTKit
//
//  Created by liuxc on 2018/5/8.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingStyleProgressView : UIView

@property (nonatomic , copy ) NSString *title;//标题文字

//开启加载动画

- (void)startLoadingAnimation;

//停止加载动画

- (void)stopLoadingAnimation;

@end
