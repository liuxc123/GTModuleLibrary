//
//  GTAlert.m
//  GTKit
//
//  Created by liuxc on 2018/5/4.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTAlert.h"

#import <Accelerate/Accelerate.h>

#import <objc/runtime.h>

#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define VIEW_WIDTH CGRectGetWidth(self.view.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)
#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, GTBackgroundStyle) {
    /** 背景样式 模糊 */
    GTBackgroundStyleBlur,
    /** 背景样式 半透明 */
    GTBackgroundStyleTranslucent,
};

@interface GTAlertConfigModel ()

@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelItemArray;
@property (nonatomic , strong ) NSMutableDictionary *modelItemInsetsInfo;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelShadowOpacity;
@property (nonatomic , assign ) CGFloat modelShadowRadius;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;
@property (nonatomic , assign ) CGFloat modelWindowLevel;
@property (nonatomic , assign ) NSInteger modelQueuePriority;

@property (nonatomic , assign ) UIColor *modelShadowColor;
@property (nonatomic , strong ) UIColor *modelHeaderColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickHeaderClose;
@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsShouldAutorotate;
@property (nonatomic , assign ) BOOL modelIsQueue;
@property (nonatomic , assign ) BOOL modelIsContinueQueueDisplay;
@property (nonatomic , assign ) BOOL modelIsAvoidKeyboard;

@property (nonatomic , assign ) CGSize modelShadowOffset;
@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , copy ) NSString *modelIdentifier;

@property (nonatomic , copy ) CGFloat (^modelMaxWidthBlock)(GTScreenOrientationType);
@property (nonatomic , copy ) CGFloat (^modelMaxHeightBlock)(GTScreenOrientationType);

@property (nonatomic , copy ) void(^modelOpenAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void(^modelCloseAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void (^modelFinishConfig)(void);
@property (nonatomic , copy ) void (^modelCloseComplete)(void);

@property (nonatomic , assign ) GTBackgroundStyle modelBackgroundStyle;
@property (nonatomic , assign ) GTAnimationStyle modelOpenAnimationStyle;
@property (nonatomic , assign ) GTAnimationStyle modelCloseAnimationStyle;

@property (nonatomic , assign ) UIBlurEffectStyle modelBackgroundBlurEffectStyle;
@property (nonatomic , assign ) UIInterfaceOrientationMask modelSupportedInterfaceOrientations;

@property (nonatomic , strong ) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic , assign ) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;

@end

@implementation GTAlertConfigModel

- (void)dealloc{
    
    _modelActionArray = nil;
    _modelItemArray = nil;
    _modelItemInsetsInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        
        _modelCornerRadius = 13.0f; //默认圆角半径
        _modelShadowOpacity = 0.3f; //默认阴影不透明度
        _modelShadowRadius = 5.0f; //默认阴影半径
        _modelShadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
        _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        _modelWindowLevel = UIWindowLevelAlert;
        _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
        
        
        _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
        _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
        _modelShadowColor = [UIColor blackColor]; //默认阴影颜色
        _modelHeaderColor = [UIColor whiteColor]; //默认颜色
        _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
        
        _modelIsClickBackgroundClose = NO; //默认点击背景不关闭
        _modelIsShouldAutorotate = YES; //默认支持自动旋转
        _modelIsQueue = NO; //默认不加入队列
        _modelIsContinueQueueDisplay = YES; //默认继续队列显示
        _modelIsAvoidKeyboard = YES; //默认闪避键盘
        
        _modelBackgroundStyle = GTBackgroundStyleTranslucent; //默认为半透明背景样式
        
        _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
        _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
        
        __weak typeof(self) weakSelf = self;
        
        _modelOpenAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelOpenAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        _modelCloseAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelCloseAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        
    }
    return self;
}

- (GTConfigToString)gt_Title{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return weakSelf.gt_AddTitle(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}


- (GTConfigToString)gt_Content{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return  weakSelf.gt_AddContent(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}

- (void)gt_Content:(NSString *)str {
    self.gt_AddContent(^(UILabel *label) {
        label.text = str;
    });
}


- (GTConfigToView)gt_CustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        return weakSelf.gt_AddCustomView(^(GTCustomView *custom) {
            
            custom.view = view;
            
            custom.positionType = GTCustomViewPositionTypeCenter;
        });
        
    };
    
}


- (GTConfigToStringAndBlock)gt_Action{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.gt_AddAction(^(GTAction *action) {
            
            action.type = GTActionTypeDefault;
            
            action.title = title;
            
            action.clickBlock = block;
        });
        
    };
    
}

- (GTConfigToStringAndBlock)gt_CancelAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.gt_AddAction(^(GTAction *action) {
            
            action.type = GTActionTypeCancel;
            
            action.title = title;
            
            action.font = [UIFont boldSystemFontOfSize:18.0f];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (GTConfigToStringAndBlock)gt_DestructiveAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.gt_AddAction(^(GTAction *action) {
            
            action.type = GTActionTypeDestructive;
            
            action.title = title;
            
            action.titleColor = [UIColor redColor];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (GTConfigToConfigLabel)gt_AddTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.gt_AddItem(^(GTItem *item) {
            
            item.type = GTItemTypeTitle;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        ;
    };
    
}

- (GTConfigToConfigLabel)gt_AddContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.gt_AddItem(^(GTItem *item) {
            
            item.type = GTItemTypeContent;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (GTConfigToCustomView)gt_AddCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(GTCustomView *custom)){
        
        return weakSelf.gt_AddItem(^(GTItem *item) {
            
            item.type = GTItemTypeCustomView;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (GTConfigToItem)gt_AddItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(GTItem *)){
        
        if (weakSelf) if (block) [weakSelf.modelItemArray addObject:block];
        
        return weakSelf;
    };
    
}

- (GTConfigToAction)gt_AddAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(GTAction *)){
        
        if (weakSelf) if (block) [weakSelf.modelActionArray addObject:block];
        
        return weakSelf;
    };
    
}

- (GTConfigToEdgeInsets)gt_HeaderInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (insets.top < 0) insets.top = 0;
            
            if (insets.left < 0) insets.left = 0;
            
            if (insets.bottom < 0) insets.bottom = 0;
            
            if (insets.right < 0) insets.right = 0;
            
            weakSelf.modelHeaderInsets = insets;
        }
        
        return weakSelf;
    };
    
}

- (GTConfigToEdgeInsets)gt_ItemInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (weakSelf.modelItemArray.count) {
                
                if (insets.top < 0) insets.top = 0;
                
                if (insets.left < 0) insets.left = 0;
                
                if (insets.bottom < 0) insets.bottom = 0;
                
                if (insets.right < 0) insets.right = 0;
                
                [weakSelf.modelItemInsetsInfo setObject:[NSValue valueWithUIEdgeInsets:insets] forKey:@(weakSelf.modelItemArray.count - 1)];
                
            } else {
                
                NSAssert(YES, @"请在添加的某一项后面设置间距");
            }
            
        }
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)gt_MaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.gt_ConfigMaxWidth(^CGFloat(GTScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (GTConfigToFloat)gt_MaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.gt_ConfigMaxHeight(^CGFloat(GTScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (GTConfigToFloatBlock)gt_ConfigMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(GTScreenOrientationType type)){
        
        if (weakSelf) if (block) weakSelf.modelMaxWidthBlock = block;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloatBlock)gt_ConfigMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(GTScreenOrientationType type)){
        
        if (weakSelf) if (block) weakSelf.modelMaxHeightBlock = block;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)gt_CornerRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCornerRadius = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)gt_OpenAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelOpenAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)gt_CloseAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCloseAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToColor)gt_HeaderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelHeaderColor = color;
        
        return weakSelf;
    };
    
}

- (GTConfigToColor)gt_BackGroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelBackgroundColor = color;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)GTBackgroundStyleTranslucent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = GTBackgroundStyleTranslucent;
            
            weakSelf.modelBackgroundStyleColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (GTConfigToBlurEffectStyle)GTBackgroundStyleBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIBlurEffectStyle style){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = GTBackgroundStyleBlur;
            
            weakSelf.modelBackgroundBlurEffectStyle = style;
        }
        
        return weakSelf;
    };
    
}

- (GTConfigToBool)gt_ClickHeaderClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsClickHeaderClose = is;
        
        return weakSelf;
    };
    
}

- (GTConfigToBool)gt_ClickBackgroundClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsClickBackgroundClose = is;
        
        return weakSelf;
    };
    
}

- (GTConfigToSize)gt_ShadowOffset{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGSize size){
        
        if (weakSelf) weakSelf.modelShadowOffset = size;
        
        return weakSelf;
    };
}

- (GTConfigToFloat)gt_ShadowOpacity{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelShadowOpacity = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)gt_ShadowRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelShadowRadius = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToColor)gt_ShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelShadowColor = color;
        
        return weakSelf;
    };
    
}

- (GTConfigToString)gt_Identifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string){
        
        if (weakSelf) weakSelf.modelIdentifier = string;
        
        return weakSelf;
    };
    
}

- (GTConfigToBool)gt_Queue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsQueue = is;
        
        return weakSelf;
    };
    
}

- (GTConfigToInteger)gt_Priority{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger number){
        
        if (weakSelf) weakSelf.modelQueuePriority = number > 0 ? number : 0;
        
        return weakSelf;
    };
    
}

- (GTConfigToBool)gt_ContinueQueueDisplay{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsContinueQueueDisplay = is;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)gt_WindowLevel{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelWindowLevel = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToBool)gt_ShouldAutorotate{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsShouldAutorotate = is;
        
        return weakSelf;
    };
    
}

- (GTConfigToInterfaceOrientationMask)gt_SupportedInterfaceOrientations{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIInterfaceOrientationMask mask){
        
        if (weakSelf) weakSelf.modelSupportedInterfaceOrientations = mask;
        
        return weakSelf;
    };
    
}

- (GTConfigToBlockAndBlock)gt_OpenAnimationConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        if (weakSelf) weakSelf.modelOpenAnimationConfigBlock = block;
        
        return weakSelf;
    };
    
}

- (GTConfigToBlockAndBlock)gt_CloseAnimationConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        if (weakSelf) weakSelf.modelCloseAnimationConfigBlock = block;
        
        return weakSelf;
    };
    
}

- (GTConfigToAnimationStyle)gt_OpenAnimationStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(GTAnimationStyle style){
        
        if (weakSelf) weakSelf.modelOpenAnimationStyle = style;
        
        return weakSelf;
    };
    
}

- (GTConfigToAnimationStyle)gt_CloseAnimationStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(GTAnimationStyle style){
        
        if (weakSelf) weakSelf.modelCloseAnimationStyle = style;
        
        return weakSelf;
    };
    
}


- (GTConfig)gt_Show{
    
    __weak typeof(self) weakSelf = self;
    
    return ^{
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig();
        }
        
        return weakSelf;
    };
    
}

#pragma mark Alert Config

- (GTConfigToConfigTextField)gt_AddTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(UITextField *)){
        
        return weakSelf.gt_AddItem(^(GTItem *item) {
            
            item.type = GTItemTypeTextField;
            
            item.insets = UIEdgeInsetsMake(10, 0, 10, 0);
            
            item.block = block;
        });
        
    };
    
}

- (GTConfigToBool)gt_AvoidKeyboard{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsAvoidKeyboard = is;
        
        return weakSelf;
    };
    
}

#pragma mark ActionSheet Config

- (GTConfigToFloat)gt_ActionSheetCancelActionSpaceWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceWidth = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToColor)gt_ActionSheetCancelActionSpaceColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceColor = color;
        
        return weakSelf;
    };
    
}

- (GTConfigToFloat)gt_ActionSheetBottomMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetBottomMargin = number;
        
        return weakSelf;
    };
    
}

- (GTConfigToBlock)gt_CloseComplete{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(void)){
        
        if (weakSelf) weakSelf.modelCloseComplete = block;
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

- (NSMutableArray *)modelActionArray{
    
    if (!_modelActionArray) _modelActionArray = [NSMutableArray array];
    
    return _modelActionArray;
}

- (NSMutableArray *)modelItemArray{
    
    if (!_modelItemArray) _modelItemArray = [NSMutableArray array];
    
    return _modelItemArray;
}

- (NSMutableDictionary *)modelItemInsetsInfo{
    
    if (!_modelItemInsetsInfo) _modelItemInsetsInfo = [NSMutableDictionary dictionary];
    
    return _modelItemInsetsInfo;
}

@end

@interface GTAlert ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) GTAlertWindow *gt_Window;

@property (nonatomic , strong ) NSMutableArray <GTAlertConfig *>*queueArray;

@property (nonatomic , strong ) GTAlertBaseViewController *viewController;

@end

@protocol GTAlertProtocol <NSObject>

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

@end

@implementation GTAlert

+ (GTAlert *)shareManager{
    
    static GTAlert *alertManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alertManager = [[GTAlert alloc] init];
    });
    
    return alertManager;
}

+ (GTAlertConfig *)alert{
    
    GTAlertConfig *config = [[GTAlertConfig alloc] init];
    
    config.type = GTAlertTypeAlert;
    
    return config;
}

+ (GTAlertConfig *)actionsheet{
    
    GTAlertConfig *config = [[GTAlertConfig alloc] init];
    
    config.type = GTAlertTypeActionSheet;
    
    config.config.gt_ClickBackgroundClose(YES);
    
    return config;
}

+ (GTAlertWindow *)getAlertWindow{
    
    return [GTAlert shareManager].gt_Window;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [GTAlert shareManager].mainWindow = window;
}

+ (void)continueQueueDisplay{
    
    if ([GTAlert shareManager].queueArray.count) [GTAlert shareManager].queueArray.lastObject.config.modelFinishConfig();
}

+ (void)clearQueue{
    
    [[GTAlert shareManager].queueArray removeAllObjects];
}

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([GTAlert shareManager].queueArray.count) {
        
        GTAlertConfig *item = [GTAlert shareManager].queueArray.lastObject;
        
        if ([item respondsToSelector:@selector(closeWithCompletionBlock:)]) [item performSelector:@selector(closeWithCompletionBlock:) withObject:completionBlock];
    }
    
}

#pragma mark LazyLoading

- (NSMutableArray <GTAlertConfig *>*)queueArray{
    
    if (!_queueArray) _queueArray = [NSMutableArray array];
    
    return _queueArray;
}

- (GTAlertWindow *)gt_Window{
    
    if (!_gt_Window) {
        
        _gt_Window = [[GTAlertWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _gt_Window.rootViewController = [[UIViewController alloc] init];
        
        _gt_Window.backgroundColor = [UIColor clearColor];
        
        _gt_Window.windowLevel = UIWindowLevelAlert;
        
        _gt_Window.hidden = YES;
    }
    
    return _gt_Window;
}

@end

@implementation GTAlertWindow

@end

@interface GTItem ()

@property (nonatomic , copy ) void (^updateBlock)(GTItem *);

@end

@implementation GTItem

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface GTAction ()

@property (nonatomic , copy ) void (^updateBlock)(GTAction *);

@end

@implementation GTAction

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface GTItemView : UIView

@property (nonatomic , strong ) GTItem *item;

+ (GTItemView *)view;

@end

@implementation GTItemView

+ (GTItemView *)view{
    
    return [[GTItemView alloc] init];;
}

@end

@interface GTItemLabel : UILabel

@property (nonatomic , strong ) GTItem *item;

@property (nonatomic , copy ) void (^textChangedBlock)(void);

+ (GTItemLabel *)label;

@end

@implementation GTItemLabel

+ (GTItemLabel *)label{
    
    return [[GTItemLabel alloc] init];
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    [super setAttributedText:attributedText];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    
    [super setNumberOfLines:numberOfLines];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

@end

@interface GTItemTextField : UITextField

@property (nonatomic , strong ) GTItem *item;

+ (GTItemTextField *)textField;

@end

@implementation GTItemTextField

+ (GTItemTextField *)textField{
    
    return [[GTItemTextField alloc] init];
}

@end

@interface GTActionButton : UIButton

@property (nonatomic , strong ) GTAction *action;

@property (nonatomic , copy ) void (^heightChangedBlock)(void);

+ (GTActionButton *)button;

@end

@interface GTActionButton ()

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) CGFloat borderWidth;

@property (nonatomic , strong ) CALayer *topLayer;

@property (nonatomic , strong ) CALayer *bottomLayer;

@property (nonatomic , strong ) CALayer *leftLayer;

@property (nonatomic , strong ) CALayer *rightLayer;

@end

@implementation GTActionButton

+ (GTActionButton *)button{
    
    return [GTActionButton buttonWithType:UIButtonTypeCustom];;
}

- (void)setAction:(GTAction *)action{
    
    _action = action;
    
    self.clipsToBounds = YES;
    
    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.attributedTitle) [self setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
    
    if (action.attributedHighlight) [self setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];
    
    if (action.font) [self.titleLabel setFont:action.font];
    
    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.highlightColor) [self setTitleColor:action.highlightColor forState:UIControlStateHighlighted];
    
    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundHighlightColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];
    
    if (action.borderColor) [self setBorderColor:action.borderColor];
    
    if (action.borderWidth > 0) [self setBorderWidth:action.borderWidth < DEFAULTBORDERWIDTH ? DEFAULTBORDERWIDTH : action.borderWidth]; else [self setBorderWidth:0.0f];
    
    if (action.image) [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];
    
    if (action.height) [self setActionHeight:action.height];
    
    if (action.cornerRadius) [self.layer setCornerRadius:action.cornerRadius];
    
    [self setImageEdgeInsets:action.imageEdgeInsets];
    
    [self setTitleEdgeInsets:action.titleEdgeInsets];
    
    if (action.borderPosition & GTActionBorderPositionTop &&
        action.borderPosition & GTActionBorderPositionBottom &&
        action.borderPosition & GTActionBorderPositionLeft &&
        action.borderPosition & GTActionBorderPositionRight) {
        
        self.layer.borderWidth = action.borderWidth;
        
        self.layer.borderColor = action.borderColor.CGColor;
        
        [self removeTopBorder];
        
        [self removeBottomBorder];
        
        [self removeLeftBorder];
        
        [self removeRightBorder];
        
    } else {
        
        self.layer.borderWidth = 0.0f;
        
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (action.borderPosition & GTActionBorderPositionTop) [self addTopBorder]; else [self removeTopBorder];
        
        if (action.borderPosition & GTActionBorderPositionBottom) [self addBottomBorder]; else [self removeBottomBorder];
        
        if (action.borderPosition & GTActionBorderPositionLeft) [self addLeftBorder]; else [self removeLeftBorder];
        
        if (action.borderPosition & GTActionBorderPositionRight) [self addRightBorder]; else [self removeRightBorder];
    }
    
    __weak typeof(self) weakSelf = self;
    
    action.updateBlock = ^(GTAction *act) {
        
        if (weakSelf) weakSelf.action = act;
    };
    
}

- (CGFloat)actionHeight{
    
    return self.frame.size.height;
}

- (void)setActionHeight:(CGFloat)height{
    
    BOOL isChange = [self actionHeight] == height ? NO : YES;
    
    CGRect buttonFrame = self.frame;
    
    buttonFrame.size.height = height;
    
    self.frame = buttonFrame;
    
    if (isChange) {
        
        if (self.heightChangedBlock) self.heightChangedBlock();
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_topLayer) _topLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.borderWidth);
    
    if (_bottomLayer) _bottomLayer.frame = CGRectMake(0, self.frame.size.height - self.borderWidth, self.frame.size.width, self.borderWidth);
    
    if (_leftLayer) _leftLayer.frame = CGRectMake(0, 0, self.borderWidth, self.frame.size.height);
    
    if (_rightLayer) _rightLayer.frame = CGRectMake(self.frame.size.width - self.borderWidth, 0, self.borderWidth, self.frame.size.height);
}

- (void)addTopBorder{
    
    [self.layer addSublayer:self.topLayer];
}

- (void)addBottomBorder{
    
    [self.layer addSublayer:self.bottomLayer];
}

- (void)addLeftBorder{
    
    [self.layer addSublayer:self.leftLayer];
}

- (void)addRightBorder{
    
    [self.layer addSublayer:self.rightLayer];
}

- (void)removeTopBorder{
    
    if (_topLayer) [_topLayer removeFromSuperlayer]; _topLayer = nil;
}

- (void)removeBottomBorder{
    
    if (_bottomLayer) [_bottomLayer removeFromSuperlayer]; _bottomLayer = nil;
}

- (void)removeLeftBorder{
    
    if (_leftLayer) [_leftLayer removeFromSuperlayer]; _leftLayer = nil;
}

- (void)removeRightBorder{
    
    if (_rightLayer) [_rightLayer removeFromSuperlayer]; _rightLayer = nil;
}

- (CALayer *)createLayer{
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = self.borderColor.CGColor;
    
    return layer;
}

- (CALayer *)topLayer{
    
    if (!_topLayer) _topLayer = [self createLayer];
    
    return _topLayer;
}

- (CALayer *)bottomLayer{
    
    if (!_bottomLayer) _bottomLayer = [self createLayer];
    
    return _bottomLayer;
}

- (CALayer *)leftLayer{
    
    if (!_leftLayer) _leftLayer = [self createLayer];
    
    return _leftLayer;
}

- (CALayer *)rightLayer{
    
    if (!_rightLayer) _rightLayer = [self createLayer];
    
    return _rightLayer;
}

- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface GTCustomView ()

@property (nonatomic , strong ) GTItem *item;

@property (nonatomic , assign ) CGSize size;

@property (nonatomic , copy ) void (^sizeChangedBlock)(void);

@end

@implementation GTCustomView

- (void)dealloc{
    
    if (_view) [_view removeObserver:self forKeyPath:@"frame"];
}

- (void)setSizeChangedBlock:(void (^)(void))sizeChangedBlock{
    
    _sizeChangedBlock = sizeChangedBlock;
    
    if (_view) {
        
        [_view layoutSubviews];
        
        _size = _view.frame.size;
        
        [_view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *view = (UIView *)object;
    
    if (!CGSizeEqualToSize(self.size, view.frame.size)) {
        
        self.size = view.frame.size;
        
        if (self.sizeChangedBlock) self.sizeChangedBlock();
    }
    
}

@end

@interface GTAlertBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong ) GTAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIVisualEffectView *backgroundVisualEffectView;

@property (nonatomic , assign ) GTScreenOrientationType orientationType;

@property (nonatomic , strong ) GTCustomView *customView;

@property (nonatomic , assign ) BOOL isShowing;

@property (nonatomic , assign ) BOOL isClosing;

@property (nonatomic , copy ) void (^openFinishBlock)(void);

@property (nonatomic , copy ) void (^closeFinishBlock)(void);

@end

@implementation GTAlertBaseViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _backgroundVisualEffectView = nil;
    
    _customView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    

    if (self.config.modelBackgroundStyle == GTBackgroundStyleBlur) {
        
        self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        
        self.backgroundVisualEffectView.frame = self.view.frame;
        
        [self.view addSubview:self.backgroundVisualEffectView];
    }
    
    self.view.backgroundColor = [self.config.modelBackgroundColor colorWithAlphaComponent:0.0f];
    
    self.orientationType = VIEW_HEIGHT > VIEW_WIDTH ? GTScreenOrientationTypeVertical : GTScreenOrientationTypeHorizontal;
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (self.backgroundVisualEffectView) self.backgroundVisualEffectView.frame = self.view.frame;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.orientationType = size.height > size.width ? GTScreenOrientationTypeVertical : GTScreenOrientationTypeHorizontal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.config.modelIsClickBackgroundClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [self.currentKeyWindow endEditing:YES];
    
    [self.view setUserInteractionEnabled:NO];
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [[GTAlert shareManager].gt_Window endEditing:YES];
}

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [GTAlert shareManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![GTAlert shareManager].mainWindow) [GTAlert shareManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

#pragma mark - 旋转

- (BOOL)shouldAutorotate{
    
    return self.config.modelIsShouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.config.modelSupportedInterfaceOrientations;
}

@end

#pragma mark - Alert

@interface GTAlertViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <id>*alertItemArray;

@property (nonatomic , strong ) NSMutableArray <GTActionButton *>*alertActionArray;

@end

@implementation GTAlertViewController
{
    CGFloat alertViewHeight;
    CGRect keyboardFrame;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    _alertView = nil;
    
    _alertItemArray = nil;
    
    _alertActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configNotification];
    
    [self configAlert];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    
    if (self.config.modelIsAvoidKeyboard) {
        
        double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        isShowingKeyboard = keyboardFrame.origin.y < SCREEN_HEIGHT;
        
        [UIView beginAnimations:@"keyboardWillChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
        [self updateAlertLayout];
        
        [UIView commitAnimations];
    }
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateAlertLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateAlertLayout];
}

- (void)updateAlertLayout{
    
    [self updateAlertLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateAlertLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    if (isShowingKeyboard) {
        
        if (keyboardFrame.size.height) {
            
            [self updateAlertItemsLayout];
            
            CGFloat keyboardY = keyboardFrame.origin.y;
            
            CGRect alertViewFrame = self.alertView.frame;
            
            CGFloat tempAlertViewHeight = keyboardY - alertViewHeight < 20 ? keyboardY - 20 : alertViewHeight;
            
            CGFloat tempAlertViewY = keyboardY - tempAlertViewHeight - 10;
            
            CGFloat originalAlertViewY = (viewHeight - alertViewFrame.size.height) * 0.5f;
            
            alertViewFrame.size.height = tempAlertViewHeight;
            
            alertViewFrame.size.width = alertViewMaxWidth;
            
            self.alertView.frame = alertViewFrame;
            
            CGRect containerFrame = self.containerView.frame;
            
            containerFrame.size.width = alertViewFrame.size.width;
            
            containerFrame.size.height = alertViewFrame.size.height;
            
            containerFrame.origin.x = (viewWidth - alertViewFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = tempAlertViewY < originalAlertViewY ? tempAlertViewY : originalAlertViewY;
            
            self.containerView.frame = containerFrame;
            
            [self.alertView scrollRectToVisible:[self findFirstResponder:self.alertView].frame animated:YES];
        }
        
    } else {
        
        [self updateAlertItemsLayout];
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.width = alertViewMaxWidth;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        self.alertView.frame = alertViewFrame;
        
        CGRect containerFrame = self.containerView.frame;
        
        containerFrame.size.width = alertViewFrame.size.width;
        
        containerFrame.size.height = alertViewFrame.size.height;
        
        containerFrame.origin.x = (viewWidth - alertViewMaxWidth) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - alertViewFrame.size.height) * 0.5f;
        
        self.containerView.frame = containerFrame;
    }
    
}

- (void)updateAlertItemsLayout{
    
    [UIView setAnimationsEnabled:NO];
    
    alertViewHeight = 0.0f;
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);

    __weak typeof(self) wself = self;
    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(wself) strongSelf = wself;

        if (idx == 0) strongSelf->alertViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            GTItemView *view = (GTItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = strongSelf->alertViewHeight + view.item.insets.top;
            
            viewFrame.size.width = alertViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            strongSelf->alertViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:GTCustomView.class]) {
            
            GTCustomView *custom = (GTCustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = GTCustomViewPositionTypeCenter;
                
                viewFrame.size.width = alertViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case GTCustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (alertViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case GTCustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case GTCustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = alertViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = strongSelf->alertViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            strongSelf->alertViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.alertItemArray.lastObject) strongSelf->alertViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (GTActionButton *button in self.alertActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = alertViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = alertViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        alertViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    if (self.alertActionArray.count == 2) {
        
        GTActionButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject : self.alertActionArray.lastObject;
        
        GTActionButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject : self.alertActionArray.firstObject;
        
        UIEdgeInsets buttonAInsets = buttonA.action.insets;
        
        UIEdgeInsets buttonBInsets = buttonB.action.insets;
        
        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame) + buttonAInsets.top + buttonAInsets.bottom;
        
        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame) + buttonBInsets.top + buttonBInsets.bottom;
        
        //CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minY = (buttonA.frame.origin.y - buttonAInsets.top) > (buttonB.frame.origin.y - buttonBInsets.top) ? (buttonB.frame.origin.y - buttonBInsets.top) : (buttonA.frame.origin.y - buttonAInsets.top);
        
        buttonA.frame = CGRectMake(buttonAInsets.left, minY + buttonAInsets.top, (alertViewMaxWidth / 2) - buttonAInsets.left - buttonAInsets.right, buttonA.frame.size.height);
        
        buttonB.frame = CGRectMake((alertViewMaxWidth / 2) + buttonBInsets.left, minY + buttonBInsets.top, (alertViewMaxWidth / 2) - buttonBInsets.left - buttonBInsets.right, buttonB.frame.size.height);
        
        alertViewHeight -= minHeight;
    }
    
    self.alertView.contentSize = CGSizeMake(alertViewMaxWidth, alertViewHeight);
    
    [UIView setAnimationsEnabled:YES];
}

- (void)configAlert{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    [self.containerView addSubview: self.alertView];
    
    self.containerView.layer.shadowOffset = self.config.modelShadowOffset;
    
    self.containerView.layer.shadowRadius = self.config.modelShadowRadius;
    
    self.containerView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    self.containerView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^itemBlock)(GTItem *) = obj;
        
        GTItem *item = [[GTItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case GTItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                GTItemLabel *label = [GTItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case GTItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                GTItemLabel *label = [GTItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case GTItemTypeCustomView:
            {
                void(^block)(GTCustomView *) = item.block;
                
                GTCustomView *custom = [[GTCustomView alloc] init];
                
                block(custom);
                
                [self.alertView addSubview:custom.view];
                
                [self.alertItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case GTItemTypeTextField:
            {
                GTItemTextField *textField = [GTItemTextField textField];
                
                textField.frame = CGRectMake(0, 0, 0, 40.0f);
                
                [self.alertView addSubview:textField];
                
                [self.alertItemArray addObject:textField];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                void(^block)(UITextField *textField) = item.block;
                
                if (block) block(textField);
                
                textField.item = item;
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    [self.config.modelActionArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^block)(GTAction *action) = item;
        
        GTAction *action = [[GTAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.borderPosition) action.borderPosition = (self.config.modelActionArray.count == 2 && idx == 0) ? GTActionBorderPositionTop | GTActionBorderPositionRight : GTActionBorderPositionTop;
        
        if (!action.height) action.height = 45.0f;
        
        GTActionButton *button = [GTActionButton button];
        
        button.action = action;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
        
        [self.alertActionArray addObject:button];
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateAlertLayout];
        };
        
    }];
    
    // 更新布局
    
    [self updateAlertLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) [weakSelf updateAlertLayout];
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    for (GTActionButton *button in self.alertActionArray) {
        
        if (button == sender) {
            
            switch (button.action.type) {
                    
                case GTActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
                    break;
                    
                case GTActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case GTActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = button.action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == GTBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            
        } else if (weakSelf.config.modelBackgroundStyle == GTBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == GTBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelBackgroundStyle == GTBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.alpha = 0.0f;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationNone) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark Tool

- (UIView *)findFirstResponder:(UIView *)view{
    
    if (view.isFirstResponder) return view;
    
    for (UIView *subView in view.subviews) {
        
        UIView *firstResponder = [self findFirstResponder:subView];
        
        if (firstResponder) return firstResponder;
    }
    
    return nil;
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.alertView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIScrollView *)alertView{
    
    if (!_alertView) {
        
        _alertView = [[UIScrollView alloc] init];
        
        _alertView.backgroundColor = self.config.modelHeaderColor;
        
        _alertView.directionalLockEnabled = YES;
        
        _alertView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_alertView addGestureRecognizer:tap];
    }
    
    return _alertView;
}

- (NSMutableArray *)alertItemArray{
    
    if (!_alertItemArray) _alertItemArray = [NSMutableArray array];
    
    return _alertItemArray;
}

- (NSMutableArray <GTActionButton *>*)alertActionArray{
    
    if (!_alertActionArray) _alertActionArray = [NSMutableArray array];
    
    return _alertActionArray;
}

@end

#pragma mark - ActionSheet

@interface GTActionSheetViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *actionSheetView;

@property (nonatomic , strong ) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic , strong ) NSMutableArray <GTActionButton *>*actionSheetActionArray;

@property (nonatomic , strong ) UIView *actionSheetCancelActionSpaceView;

@property (nonatomic , strong ) GTActionButton *actionSheetCancelAction;

@end

@implementation GTActionSheetViewController
{
    BOOL isShowed;
}

- (void)dealloc{
    
    _actionSheetView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configActionSheet];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateActionSheetLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateActionSheetLayout];
}

- (void)updateActionSheetLayout{
    
    [self updateActionSheetLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateActionSheetLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    [UIView setAnimationsEnabled:NO];
    
    __block CGFloat actionSheetViewHeight = 0.0f;
    
    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) actionSheetViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            GTItemView *view = (GTItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = actionSheetViewHeight + view.item.insets.top;
            
            viewFrame.size.width = actionSheetViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            actionSheetViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:GTCustomView.class]) {
            
            GTCustomView *custom = (GTCustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = GTCustomViewPositionTypeCenter;
                
                viewFrame.size.width = actionSheetViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case GTCustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (actionSheetViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case GTCustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case GTCustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = actionSheetViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = actionSheetViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            actionSheetViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (GTActionButton *button in self.actionSheetActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = actionSheetViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = actionSheetViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    self.actionSheetView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionSheetViewHeight);
    
    [UIView setAnimationsEnabled:YES];
    
    CGFloat cancelActionTotalHeight = self.actionSheetCancelAction ? self.actionSheetCancelAction.actionHeight + self.config.modelActionSheetCancelActionSpaceWidth : 0.0f;
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight - cancelActionTotalHeight ? actionSheetViewMaxHeight - cancelActionTotalHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.x = 0;
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect spaceFrame = self.actionSheetCancelActionSpaceView.frame;
        
        spaceFrame.origin.x = 0;
        
        spaceFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height;
        
        spaceFrame.size.width = actionSheetViewMaxWidth;
        
        spaceFrame.size.height = self.config.modelActionSheetCancelActionSpaceWidth;
        
        self.actionSheetCancelActionSpaceView.frame = spaceFrame;
        
        CGRect buttonFrame = self.actionSheetCancelAction.frame;
        
        buttonFrame.origin.x = 0;
        
        buttonFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height + spaceFrame.size.height;
        
        buttonFrame.size.width = actionSheetViewMaxWidth;
        
        self.actionSheetCancelAction.frame = buttonFrame;
    }
    
    CGRect containerFrame = self.containerView.frame;
    
    containerFrame.size.width = actionSheetViewFrame.size.width;
    
    containerFrame.size.height = actionSheetViewFrame.size.height + cancelActionTotalHeight;
    
    containerFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
    
    if (isShowed) {
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height - VIEWSAFEAREAINSETS(self.view).bottom) - self.config.modelActionSheetBottomMargin;
        
    } else {
        
        containerFrame.origin.y = viewHeight;
    }
    
    self.containerView.frame = containerFrame;
}

- (void)configActionSheet{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    [self.containerView addSubview: self.actionSheetView];
    
    self.containerView.layer.shadowOffset = self.config.modelShadowOffset;
    
    self.containerView.layer.shadowRadius = self.config.modelShadowRadius;
    
    self.containerView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    self.containerView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    self.actionSheetView.layer.cornerRadius = self.config.modelCornerRadius;
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^itemBlock)(GTItem *) = obj;
        
        GTItem *item = [[GTItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case GTItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                GTItemLabel *label = [GTItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case GTItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                GTItemLabel *label = [GTItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor grayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case GTItemTypeCustomView:
            {
                void(^block)(GTCustomView *) = item.block;
                
                GTCustomView *custom = [[GTCustomView alloc] init];
                
                block(custom);
                
                [self.actionSheetView addSubview:custom.view];
                
                [self.actionSheetItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
            default:
                break;
        }
        
    }];
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(GTAction *action) = item;
        
        GTAction *action = [[GTAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.86 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.height) action.height = 57.0f;
        
        GTActionButton *button = [GTActionButton button];
        
        switch (action.type) {
                
            case GTActionTypeCancel:
            {
                [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                button.layer.cornerRadius = self.config.modelCornerRadius;
                
                button.backgroundColor = action.backgroundColor;
                
                [self.containerView addSubview:button];
                
                self.actionSheetCancelAction = button;
                
                self.actionSheetCancelActionSpaceView = [[UIView alloc] init];
                
                self.actionSheetCancelActionSpaceView.backgroundColor = self.config.modelActionSheetCancelActionSpaceColor;
                
                [self.containerView addSubview:self.actionSheetCancelActionSpaceView];
            }
                break;
                
            default:
            {
                if (!action.borderPosition) action.borderPosition = GTActionBorderPositionTop;
                
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.actionSheetView addSubview:button];
                
                [self.actionSheetActionArray addObject:button];
            }
                break;
        }
        
        button.action = action;
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateActionSheetLayout];
        };
    }
    
    // 更新布局
    
    [self updateActionSheetLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) {
            
            [weakSelf updateActionSheetLayout];
        }
        
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    for (GTActionButton *button in self.actionSheetActionArray) {
        
        if (button == sender) {
            
            switch (button.action.type) {
                    
                case GTActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
                    break;
                    
                case GTActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case GTActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = button.action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)cancelButtonAction:(UIButton *)sender{
    
    void (^clickBlock)(void) = self.actionSheetCancelAction.action.clickBlock;
    
    [self closeAnimationsWithCompletionBlock:^{
        
        if (clickBlock) clickBlock();
    }];
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    isShowed = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & GTAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & GTAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case GTBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
            }
                break;
                
            case GTBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.config.modelBackgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - weakSelf.config.modelActionSheetBottomMargin - VIEWSAFEAREAINSETS(weakSelf.view).bottom;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    isShowed = NO;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case GTBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.alpha = 0.0f;
            }
                break;
                
            case GTBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationNone) {
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & GTAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.actionSheetView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIView *)actionSheetView{
    
    if (!_actionSheetView) {
        
        _actionSheetView = [[UIScrollView alloc] init];
        
        _actionSheetView.backgroundColor = self.config.modelHeaderColor;
        
        _actionSheetView.directionalLockEnabled = YES;
        
        _actionSheetView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_actionSheetView addGestureRecognizer:tap];
    }
    
    return _actionSheetView;
}

- (NSMutableArray <id>*)actionSheetItemArray{
    
    if (!_actionSheetItemArray) _actionSheetItemArray = [NSMutableArray array];
    
    return _actionSheetItemArray;
}

- (NSMutableArray <GTActionButton *>*)actionSheetActionArray{
    
    if (!_actionSheetActionArray) _actionSheetActionArray = [NSMutableArray array];
    
    return _actionSheetActionArray;
}

@end

@interface GTAlertConfig ()<GTAlertProtocol>

@end

@implementation GTAlertConfig

- (void)dealloc{
    
    _config = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        
        self.config.modelFinishConfig = ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (!strongSelf) return;
            
            if ([GTAlert shareManager].queueArray.count) {
                
                GTAlertConfig *last = [GTAlert shareManager].queueArray.lastObject;
                
                if (!strongSelf.config.modelIsQueue && last.config.modelQueuePriority > strongSelf.config.modelQueuePriority) return;
                
                if (!last.config.modelIsQueue && last.config.modelQueuePriority <= strongSelf.config.modelQueuePriority) [[GTAlert shareManager].queueArray removeObject:last];
                
                if (![[GTAlert shareManager].queueArray containsObject:strongSelf]) {
                    
                    [[GTAlert shareManager].queueArray addObject:strongSelf];
                    
                    [[GTAlert shareManager].queueArray sortUsingComparator:^NSComparisonResult(GTAlertConfig *configA, GTAlertConfig *configB) {
                        
                        return configA.config.modelQueuePriority > configB.config.modelQueuePriority ? NSOrderedDescending
                        : configA.config.modelQueuePriority == configB.config.modelQueuePriority ? NSOrderedSame : NSOrderedAscending;
                    }];
                    
                }
                
                if ([GTAlert shareManager].queueArray.lastObject == strongSelf) [strongSelf show];
                
            } else {
                
                [strongSelf show];
                
                [[GTAlert shareManager].queueArray addObject:strongSelf];
            }
            
        };
        
    }
    
    return self;
}

- (void)setType:(GTAlertType)type{
    
    _type = type;
    
    // 处理默认值
    
    switch (type) {
            
        case GTAlertTypeAlert:
            
            self.config
            .gt_ConfigMaxWidth(^CGFloat(GTScreenOrientationType type) {
                
                return 280.0f;
            })
            .gt_ConfigMaxHeight(^CGFloat(GTScreenOrientationType type) {
                
                return SCREEN_HEIGHT - 40.0f - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).bottom;
            })
            .gt_OpenAnimationStyle(GTAnimationStyleOrientationNone | GTAnimationStyleFade | GTAnimationStyleZoomEnlarge)
            .gt_CloseAnimationStyle(GTAnimationStyleOrientationNone | GTAnimationStyleFade | GTAnimationStyleZoomShrink);
            
            break;
            
        case GTAlertTypeActionSheet:
            
            self.config
            .gt_ConfigMaxWidth(^CGFloat(GTScreenOrientationType type) {
                
                return type == GTScreenOrientationTypeHorizontal ? SCREEN_HEIGHT - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).bottom - 20.0f : SCREEN_WIDTH - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).left - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).right - 20.0f;
            })
            .gt_ConfigMaxHeight(^CGFloat(GTScreenOrientationType type) {
                
                return SCREEN_HEIGHT - 40.0f - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([GTAlert getAlertWindow]).bottom;
            })
            .gt_OpenAnimationStyle(GTAnimationStyleOrientationBottom)
            .gt_CloseAnimationStyle(GTAnimationStyleOrientationBottom);
            
            break;
            
        default:
            break;
    }
    
}

- (void)show{
    
    switch (self.type) {
            
        case GTAlertTypeAlert:
            
            [GTAlert shareManager].viewController = [[GTAlertViewController alloc] init];
            
            break;
            
        case GTAlertTypeActionSheet:
            
            [GTAlert shareManager].viewController = [[GTActionSheetViewController alloc] init];
            
            break;
            
        default:
            break;
    }
    
    if (![GTAlert shareManager].viewController) return;
    
    [GTAlert shareManager].viewController.config = self.config;
    
    [GTAlert shareManager].gt_Window.rootViewController = [GTAlert shareManager].viewController;
    
    [GTAlert shareManager].gt_Window.windowLevel = self.config.modelWindowLevel;
    
    [GTAlert shareManager].gt_Window.hidden = NO;
    
    [[GTAlert shareManager].gt_Window makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    [GTAlert shareManager].viewController.openFinishBlock = ^{
        
    };
    
    [GTAlert shareManager].viewController.closeFinishBlock = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return;
        
        if ([GTAlert shareManager].queueArray.lastObject == strongSelf) {
            
            [GTAlert shareManager].gt_Window.hidden = YES;
            
            [[GTAlert shareManager].gt_Window resignKeyWindow];
            
            [GTAlert shareManager].gt_Window.rootViewController = nil;
            
            [GTAlert shareManager].viewController = nil;
            
            [[GTAlert shareManager].queueArray removeObject:strongSelf];
            
            if (strongSelf.config.modelIsContinueQueueDisplay) [GTAlert continueQueueDisplay];
            
        } else {
            
            [[GTAlert shareManager].queueArray removeObject:strongSelf];
        }
        
        if (strongSelf.config.modelCloseComplete) strongSelf.config.modelCloseComplete();
    };
    
}

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([GTAlert shareManager].viewController) [[GTAlert shareManager].viewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark - LazyLoading

- (GTAlertConfigModel *)config{
    
    if (!_config) _config = [[GTAlertConfigModel alloc] init];
    
    return _config;
}

@end
