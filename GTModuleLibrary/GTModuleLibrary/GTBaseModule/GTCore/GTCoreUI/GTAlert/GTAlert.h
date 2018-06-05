//
//  GTAlert.h
//  GTKit
//
//  Created by liuxc on 2018/5/4.
//  Copyright © 2018年 liuxc. All rights reserved.
//  https://github.com/lixiang1994/LEEAlert

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GTAlertDefine.h"


/*
 *************************简要说明************************
 
 Alert 使用方法
 
 [GTAlert alert].cofing.XXXXX.XXXXX.gt_Show();
 
 ActionSheet 使用方法
 
 [GTAlert actionSheet].cofing.XXXXX.XXXXX.gt_Show();
 
 特性:
 - 支持alert类型与actionsheet类型
 - 默认样式为Apple风格 可自定义其样式
 - 支持自定义标题与内容 可动态调整其样式
 - 支持自定义视图添加 同时可设置位置类型等 自定义视图size改变时会自动适应.
 - 支持输入框添加 自动处理键盘相关的细节
 - 支持屏幕旋转适应 同时可自定义横竖屏最大宽度和高度
 - 支持自定义action添加 可动态调整其样式
 - 支持内部添加的功能项的间距范围设置等
 - 支持圆角设置 支持阴影效果设置
 - 支持队列和优先级 多个同时显示时根据优先级顺序排队弹出 添加到队列的如被高优先级覆盖 以后还会继续显示.
 - 支持两种背景样式 1.半透明 (支持自定义透明度比例和颜色) 2.毛玻璃 (支持效果类型)
 - 支持自定义UIView动画方法
 - 支持自定义打开关闭动画样式(动画方向 渐变过渡 缩放过渡等)
 - 更多特性未来版本中将不断更新.
 
 设置方法结束后在最后请不要忘记使用.gt_Show()方法来显示.
 
 最低支持iOS8及以上
 
 *****************************************************
 */

@interface GTAlert : NSObject

/** 初始化 */

+ (GTAlertConfig *)alert;

+ (GTAlertConfig *)actionsheet;

/** 获取Alert窗口 */

+ (GTAlertWindow *)getAlertWindow;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow *)window;

/** 继续队列显示 */

+ (void)continueQueueDisplay;

/** 清空队列 */

+ (void)clearQueue;

/** 关闭 */

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

@end

@interface GTAlertConfigModel : NSObject

/** ✨通用设置 */

/** 设置 标题 -> 格式: .gt_Title(@@"") */
@property (nonatomic , copy , readonly ) GTConfigToString gt_Title;

/** 设置 内容 -> 格式: .gt_Content(@@"") */
@property (nonatomic , copy , readonly ) GTConfigToString gt_Content;

/** 设置 自定义视图 -> 格式: .gt_CustomView(UIView) */
@property (nonatomic , copy , readonly ) GTConfigToView gt_CustomView;

/** 设置 动作 -> 格式: .gt_Action(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToStringAndBlock gt_Action;

/** 设置 取消动作 -> 格式: .gt_CancelAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToStringAndBlock gt_CancelAction;

/** 设置 取消动作 -> 格式: .gt_DestructiveAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToStringAndBlock gt_DestructiveAction;

/** 设置 添加标题 -> 格式: .gt_ConfigTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToConfigLabel gt_AddTitle;

/** 设置 添加内容 -> 格式: .gt_ConfigContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToConfigLabel gt_AddContent;

/** 设置 添加自定义视图 -> 格式: .gt_AddCustomView(^(GTCustomView *){ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToCustomView gt_AddCustomView;

/** 设置 添加一项 -> 格式: .gt_AddItem(^(GTItem *){ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToItem gt_AddItem;

/** 设置 添加动作 -> 格式: .gt_AddAction(^(GTAction *){ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToAction gt_AddAction;

/** 设置 头部内的间距 -> 格式: .gt_HeaderInsets(UIEdgeInsetsMake(20, 20, 20, 20)) */
@property (nonatomic , copy , readonly ) GTConfigToEdgeInsets gt_HeaderInsets;

/** 设置 上一项的间距 (在它之前添加的项的间距) -> 格式: .gt_ItemInsets(UIEdgeInsetsMake(5, 0, 5, 0)) */
@property (nonatomic , copy , readonly ) GTConfigToEdgeInsets gt_ItemInsets;

/** 设置 最大宽度 -> 格式: .gt_MaxWidth(280.0f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_MaxWidth;

/** 设置 最大高度 -> 格式: .gt_MaxHeight(400.0f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_MaxHeight;

/** 设置 设置最大宽度 -> 格式: .gt_ConfigMaxWidth(CGFloat(^)(^CGFloat(GTScreenOrientationType type) { return 280.0f; }) */
@property (nonatomic , copy , readonly ) GTConfigToFloatBlock gt_ConfigMaxWidth;

/** 设置 设置最大高度 -> 格式: .gt_ConfigMaxHeight(CGFloat(^)(^CGFloat(GTScreenOrientationType type) { return 600.0f; }) */
@property (nonatomic , copy , readonly ) GTConfigToFloatBlock gt_ConfigMaxHeight;

/** 设置 圆角半径 -> 格式: .gt_CornerRadius(13.0f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_CornerRadius;

/** 设置 开启动画时长 -> 格式: .gt_OpenAnimationDuration(0.3f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_OpenAnimationDuration;

/** 设置 关闭动画时长 -> 格式: .gt_CloseAnimationDuration(0.2f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_CloseAnimationDuration;

/** 设置 颜色 -> 格式: .gt_HeaderColor(UIColor) */
@property (nonatomic , copy , readonly ) GTConfigToColor gt_HeaderColor;

/** 设置 背景颜色 -> 格式: .gt_BackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) GTConfigToColor gt_BackGroundColor;

/** 设置 半透明背景样式及透明度 [默认] -> 格式: .gt_BackgroundStyleTranslucent(0.45f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_BackgroundStyleTranslucent;

/** 设置 模糊背景样式及类型 -> 格式: .gt_BackgroundStyleBlur(UIBlurEffectStyleDark) */
@property (nonatomic , copy , readonly ) GTConfigToBlurEffectStyle gt_BackgroundStyleBlur;

/** 设置 点击头部关闭 -> 格式: .gt_ClickHeaderClose(YES) */
@property (nonatomic , copy , readonly ) GTConfigToBool gt_ClickHeaderClose;

/** 设置 点击背景关闭 -> 格式: .gt_ClickBackgroundClose(YES) */
@property (nonatomic , copy , readonly ) GTConfigToBool gt_ClickBackgroundClose;

/** 设置 阴影偏移 -> 格式: .gt_ShadowOffset(CGSizeMake(0.0f, 2.0f)) */
@property (nonatomic , copy , readonly ) GTConfigToSize gt_ShadowOffset;

/** 设置 阴影不透明度 -> 格式: .gt_ShadowOpacity(0.3f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_ShadowOpacity;

/** 设置 阴影半径 -> 格式: .gt_ShadowRadius(5.0f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_ShadowRadius;

/** 设置 阴影颜色 -> 格式: .gt_ShadowOpacity(UIColor) */
@property (nonatomic , copy , readonly ) GTConfigToColor gt_ShadowColor;

/** 设置 标识 -> 格式: .gt_Identifier(@@"ident") */
//@property (nonatomic , copy , readonly ) GTConfigToString gt_Identifier;

/** 设置 是否加入到队列 -> 格式: .gt_Queue(YES) */
@property (nonatomic , copy , readonly ) GTConfigToBool gt_Queue;

/** 设置 优先级 -> 格式: .gt_Priority(1000) */
@property (nonatomic , copy , readonly ) GTConfigToInteger gt_Priority;

/** 设置 是否继续队列显示 -> 格式: .gt_ContinueQueue(YES) */
@property (nonatomic , copy , readonly ) GTConfigToBool gt_ContinueQueueDisplay;

/** 设置 window等级 -> 格式: .gt_WindowLevel(UIWindowLevel) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_WindowLevel;

/** 设置 是否支持自动旋转 -> 格式: .gt_ShouldAutorotate(YES) */
@property (nonatomic , copy , readonly ) GTConfigToBool gt_ShouldAutorotate;

/** 设置 是否支持显示方向 -> 格式: .gt_ShouldAutorotate(UIInterfaceOrientationMaskAll) */
@property (nonatomic , copy , readonly ) GTConfigToInterfaceOrientationMask gt_SupportedInterfaceOrientations;

/** 设置 打开动画配置 -> 格式: .gt_OpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToBlockAndBlock gt_OpenAnimationConfig;

/** 设置 关闭动画配置 -> 格式: .gt_CloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToBlockAndBlock gt_CloseAnimationConfig;

/** 设置 打开动画样式 -> 格式: .gt_OpenAnimationStyle() */
@property (nonatomic , copy , readonly ) GTConfigToAnimationStyle gt_OpenAnimationStyle;

/** 设置 关闭动画样式 -> 格式: .gt_CloseAnimationStyle() */
@property (nonatomic , copy , readonly ) GTConfigToAnimationStyle gt_CloseAnimationStyle;


/** 显示  -> 格式: .gt_Show() */
@property (nonatomic , copy , readonly ) GTConfig gt_Show;

/** ✨alert 专用设置 */

/** 设置 添加输入框 -> 格式: .gt_AddTextField(^(UITextField *){ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToConfigTextField gt_AddTextField;

/** 设置 是否闪避键盘 -> 格式: .gt_AvoidKeyboard(YES) */
@property (nonatomic , copy , readonly ) GTConfigToBool gt_AvoidKeyboard;

/** ✨actionSheet 专用设置 */

/** 设置 取消动作的间隔宽度 -> 格式: .gt_ActionSheetCancelActionSpaceWidth(10.0f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_ActionSheetCancelActionSpaceWidth;

/** 设置 取消动作的间隔颜色 -> 格式: .gt_ActionSheetCancelActionSpaceColor(UIColor) */
@property (nonatomic , copy , readonly ) GTConfigToColor gt_ActionSheetCancelActionSpaceColor;

/** 设置 ActionSheet距离屏幕底部的间距 -> 格式: .gt_ActionSheetBottomMargin(10.0f) */
@property (nonatomic , copy , readonly ) GTConfigToFloat gt_ActionSheetBottomMargin;



/** 设置 当前关闭回调 -> 格式: .gt_CloseComplete(^{ //code.. }) */
@property (nonatomic , copy , readonly ) GTConfigToBlock gt_CloseComplete;

@end


@interface GTItem : NSObject

/** item类型 */
@property (nonatomic , assign ) GTItemType type;

/** item间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** item设置视图Block */
@property (nonatomic , copy ) void (^block)(id view);

- (void)update;

@end

@interface GTAction : NSObject

/** action类型 */
@property (nonatomic , assign ) GTActionType type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) GTActionBorderPosition borderPosition;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^clickBlock)(void);

- (void)update;

@end

@interface GTCustomView : NSObject

/** 自定义视图对象 */
@property (nonatomic , strong ) UIView *view;

/** 自定义视图位置类型 (默认为居中) */
@property (nonatomic , assign ) GTCustomViewPositionType positionType;

/** 是否自动适应宽度 */
@property (nonatomic , assign ) BOOL isAutoWidth;

@end

@interface GTAlertConfig : NSObject

@property (nonatomic , strong ) GTAlertConfigModel *config;

@property (nonatomic , assign ) GTAlertType type;

@end


@interface GTAlertWindow : UIWindow @end

@interface GTAlertBaseViewController : UIViewController @end

@interface GTAlertViewController : GTAlertBaseViewController @end

@interface GTActionSheetViewController : GTAlertBaseViewController @end
