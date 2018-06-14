//
//  GTProgressView.h
//  GTKit
//
//  Created by liuxc on 2018/5/8.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, GTProgressIndicatorStyle) {

    GTProgressIndicatorStyleNormal = 0,

    GTProgressIndicatorStyleLarge = 1,
};

@interface GTProgressView : UIView

@property (assign, nonatomic) GTProgressIndicatorStyle progressIndicatorStyle;

@property (strong, nonatomic) UIColor *strokeColor;

- (instancetype)initWithProgressIndicatorStyle:(GTProgressIndicatorStyle)style;

- (void)startProgressAnimating;

- (void)stopProgressAnimating;

@end
