//
//  GTSuccessView.h
//  GTKit
//
//  Created by liuxc on 2018/5/8.
//  Copyright © 2018年 liuxc. All rights reserved.
//
//
//----------------------------------------------------
//              打勾、打叉动画
//----------------------------------------------------

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GTAnimationType) {
    GTAnimationTypeNone,
    /* 成功 */
    GTAnimationTypeSuccess,
    /* 失败 */
    GTAnimationTypeError,
};

@interface GTSuccessView : UIView<CAAnimationDelegate>

/**
 *  操作成功还是失败类型的动画
 */
@property(nonatomic, assign) GTAnimationType gt_animationType;

@end

NS_ASSUME_NONNULL_END
