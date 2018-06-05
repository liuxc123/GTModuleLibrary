//
//  GTAlertDefine.h
//  GTKit
//
//  Created by liuxc on 2018/5/4.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#ifndef GTAlertDefine_h
#define GTAlertDefine_h

@class GTAlert , GTAlertConfig , GTAlertConfigModel , GTAlertWindow , GTAction , GTItem , GTCustomView;

typedef NS_ENUM(NSInteger, GTScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    GTScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    GTScreenOrientationTypeVertical
};


typedef NS_ENUM(NSInteger, GTAlertType) {
    
    GTAlertTypeAlert,
    
    GTAlertTypeActionSheet
};


typedef NS_ENUM(NSInteger, GTActionType) {
    /** 默认 */
    GTActionTypeDefault,
    /** 取消 */
    GTActionTypeCancel,
    /** 销毁 */
    GTActionTypeDestructive
};


typedef NS_OPTIONS(NSInteger, GTActionBorderPosition) {
    /** Action边框位置 上 */
    GTActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    GTActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    GTActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    GTActionBorderPositionRight    = 1 << 3
};


typedef NS_ENUM(NSInteger, GTItemType) {
    /** 标题 */
    GTItemTypeTitle,
    /** 内容 */
    GTItemTypeContent,
    /** 输入框 */
    GTItemTypeTextField,
    /** 自定义视图 */
    GTItemTypeCustomView,
};


typedef NS_ENUM(NSInteger, GTCustomViewPositionType) {
    /** 居中 */
    GTCustomViewPositionTypeCenter,
    /** 靠左 */
    GTCustomViewPositionTypeLeft,
    /** 靠右 */
    GTCustomViewPositionTypeRight
};

typedef NS_OPTIONS(NSInteger, GTAnimationStyle) {
    /** 动画样式方向 默认 */
    GTAnimationStyleOrientationNone    = 1 << 0,
    /** 动画样式方向 上 */
    GTAnimationStyleOrientationTop     = 1 << 1,
    /** 动画样式方向 下 */
    GTAnimationStyleOrientationBottom  = 1 << 2,
    /** 动画样式方向 左 */
    GTAnimationStyleOrientationLeft    = 1 << 3,
    /** 动画样式方向 右 */
    GTAnimationStyleOrientationRight   = 1 << 4,
    
    /** 动画样式 淡入淡出 */
    GTAnimationStyleFade               = 1 << 12,
    
    /** 动画样式 缩放 放大 */
    GTAnimationStyleZoomEnlarge        = 1 << 24,
    /** 动画样式 缩放 缩小 */
    GTAnimationStyleZoomShrink         = 2 << 24,
};

typedef GTAlertConfigModel *(^GTConfig)(void);
typedef GTAlertConfigModel *(^GTConfigToBool)(BOOL is);
typedef GTAlertConfigModel *(^GTConfigToInteger)(NSInteger number);
typedef GTAlertConfigModel *(^GTConfigToFloat)(CGFloat number);
typedef GTAlertConfigModel *(^GTConfigToString)(NSString *str);
typedef GTAlertConfigModel *(^GTConfigToView)(UIView *view);
typedef GTAlertConfigModel *(^GTConfigToColor)(UIColor *color);
typedef GTAlertConfigModel *(^GTConfigToSize)(CGSize size);
typedef GTAlertConfigModel *(^GTConfigToEdgeInsets)(UIEdgeInsets insets);
typedef GTAlertConfigModel *(^GTConfigToAnimationStyle)(GTAnimationStyle style);
typedef GTAlertConfigModel *(^GTConfigToBlurEffectStyle)(UIBlurEffectStyle style);
typedef GTAlertConfigModel *(^GTConfigToInterfaceOrientationMask)(UIInterfaceOrientationMask);
typedef GTAlertConfigModel *(^GTConfigToFloatBlock)(CGFloat(^)(GTScreenOrientationType type));
typedef GTAlertConfigModel *(^GTConfigToAction)(void(^)(GTAction *action));
typedef GTAlertConfigModel *(^GTConfigToCustomView)(void(^)(GTCustomView *custom));
typedef GTAlertConfigModel *(^GTConfigToStringAndBlock)(NSString *str , void (^)(void));
typedef GTAlertConfigModel *(^GTConfigToConfigLabel)(void(^)(UILabel *label));
typedef GTAlertConfigModel *(^GTConfigToConfigTextField)(void(^)(UITextField *textField));
typedef GTAlertConfigModel *(^GTConfigToItem)(void(^)(GTItem *item));
typedef GTAlertConfigModel *(^GTConfigToBlock)(void(^block)(void));
typedef GTAlertConfigModel *(^GTConfigToBlockAndBlock)(void(^)(void (^animatingBlock)(void) , void (^animatedBlock)(void)));


#endif /* GTAlertDefine_h */
