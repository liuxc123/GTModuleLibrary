//
//  GTProgressHUD.m
//  GTKit
//
//  Created by liuxc on 2018/5/9.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTProgressHUD.h"
#import "GTSuccessView.h"
#import <objc/message.h>

CGFloat const delayTime = 1.2;
#define kLoadImage(name) [UIImage imageNamed:[NSString stringWithFormat:@"GTProgressHUD.bundle/%@", (name)]]
#define TEXT_SIZE    16.0f


@implementation GTProgressHUD

NS_INLINE GTProgressHUD *createNew(UIView *view) {
    return [GTProgressHUD showHUDAddedTo:[GTProgressHUD getMainView:view] animated:YES];
}

NS_INLINE GTProgressHUD *settHUD(UIView *view, NSString *title, BOOL autoHidden) {
    GTProgressHUD *hud = createNew(view);
    //文字
    hud.label.text = title;
    //支持多行
    hud.label.numberOfLines = 0;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 动画
    hud.animationType = MBProgressHUDAnimationZoom;

    //设置副标题字体大小
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];

    //设置默认风格
    if (GTDefaultHudStyle == 1) {
        hud.hudContentStyle(GTHUDContentBlackStyle);

    } else if (GTDefaultHudStyle == 2) {
        hud.hudContentStyle(GTHUDContentCustomStyle);
    }

    if (autoHidden) {
        // x秒之后消失
        [hud hideAnimated:YES afterDelay:delayTime];
    }


    return hud;
}

+ (UIView *)getMainView:(UIView *)view {
    return (view == nil) ? (UIView*)[UIApplication sharedApplication].delegate.window : view;
}



+ (void)showMessage:(NSString *)text {
    GTProgressHUD *hud = settHUD(nil, text, YES);
    hud.mode = MBProgressHUDModeText;
}

+ (void)showMessage:(NSString *)text view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.mode = MBProgressHUDModeText;
}

+ (void)showMessage:(NSString *)text postion:(GTHUDPostion)postion view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

+ (void)showMessage:(NSString *)text contentStyle:(GTHUDContentStyle)contentStyle afterDelay:(NSTimeInterval)delay view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showDetailMessage:(NSString *)text detail:(NSString *)detail {
    GTProgressHUD *hud = settHUD(nil, text, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
}

+ (void)showDetailMessage:(NSString *)text detail:(NSString *)detail view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
}

+ (void)showDetailMessage:(NSString *)text postion:(GTHUDPostion)postion detail:(NSString *)detail view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

+  (void)showInfoMsg:(NSString *)text {
    [GTProgressHUD showInfoMsg:text view:nil];
}

+  (void)showInfoMsg:(NSString *)text view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gt_hud_info@2x.png"]];
    hud.square = YES;
}

+ (void)showSuccess:(NSString *)text {
    [GTProgressHUD showSuccess:text view:nil];
}

+ (void)showSuccess:(NSString *)text view:(UIView *)view {
    GTSuccessView *suc = [[GTSuccessView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    suc.gt_animationType = GTAnimationTypeSuccess;

    suc.translatesAutoresizingMaskIntoConstraints = NO;
    [suc addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[suc(==40)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(suc)]];
    [suc addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[suc(==40)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(suc)]];


    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = suc;
    hud.square = YES;
}

+ (void)showFailure:(NSString *)text {
    [GTProgressHUD showFailure:text view:nil];
}

+ (void)showFailure:(NSString *)text view:(UIView *)view {
    GTSuccessView *suc = [[GTSuccessView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    suc.gt_animationType = GTAnimationTypeError;

    suc.translatesAutoresizingMaskIntoConstraints = NO;
    [suc addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[suc(==40)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(suc)]];
    [suc addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[suc(==40)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(suc)]];

    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = suc;
    hud.square = YES;
}

+ (void)showWarningMsg:(NSString *)text {
    [GTProgressHUD showWarningMsg:text view:nil];
}

+ (void)showWarningMsg:(NSString *)text view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gt_hud_warning.png"]];
    hud.square = YES;
}

+ (void)showLoading {
    GTProgressHUD *hud = settHUD(nil, nil, NO);
    hud.square = YES;
}

+ (void)showLoading:(NSString *)text {
    GTProgressHUD *hud = settHUD(nil, text, NO);
    hud.square = YES;
}

+ (void)showLoading:(NSString *)text view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    hud.square = YES;
}

+ (void)showCustomView:(UIImage *)image text:(NSString *)text view:(UIView *)view  {
    GTProgressHUD *hud = settHUD(view, text, YES);
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
}




+ (GTProgressHUD *)showMessage:(NSString *)text contentStyle:(GTHUDContentStyle)contentStyle view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    return hud;
}

+ (GTProgressHUD *)showDown:(NSString *)text progressStyle:(GTHUDProgressStyle)progressStyle progress:(GTCurrentHud)progress view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    if (progressStyle == GTHUDProgressStyleDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;

    } else if (progressStyle == GTHUDProgressStyleDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;

    } else if (progressStyle == GTHUDProgressStyleAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    if (progress) {
        progress(hud);
    }
    return hud;
}


+ (GTProgressHUD *)showDown:(NSString *)text cancelText:(NSString *)cancelText progressStyle:(GTHUDProgressStyle)progressStyle progress:(GTCurrentHud)progress view:(UIView *)view cancelation:(GTCancelation)cancelation  {
    GTProgressHUD *hud = settHUD(view, text, NO);

    if (progressStyle == GTHUDProgressStyleDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;

    } else if (progressStyle == GTHUDProgressStyleDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;

    } else if (progressStyle == GTHUDProgressStyleAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }

    [hud.button setTitle:cancelText ?: NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:hud action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    hud.cancelation = cancelation;
    if (progress) {
        progress(hud);
    }
    return hud;
}

+ (GTProgressHUD *)showDownNSProgress:(NSString *)text progress:(NSProgress *)progress view:(UIView *)view configHud:(GTCurrentHud)configHud {
    GTProgressHUD *hud = settHUD(view, text, NO);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}

+ (GTProgressHUD *)showMessage:(NSString *)text backgroundColor:(UIColor *)backgroundColor view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = backgroundColor;
    return hud;
}

+ (GTProgressHUD *)showMessage:(NSString *)text contentColor:(UIColor *)contentColor view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    hud.contentColor = contentColor;
    return hud;
}

+ (GTProgressHUD *)showMessage:(NSString *)text contentColor:(UIColor *)contentColor backgroundColor:(UIColor *)backgroundColor view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    hud.contentColor = contentColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}

+ (GTProgressHUD *)showMessage:(NSString *)text textColor:(UIColor *)textColor bezelViewColor:(UIColor *)bezelViewColor backgroundColor:(UIColor *)backgroundColor view:(UIView *)view {
    GTProgressHUD *hud = settHUD(view, text, NO);
    hud.label.textColor = textColor;
    hud.bezelView.backgroundColor = bezelViewColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}

+ (GTProgressHUD *)createHud:(NSString *)text view:(UIView *)view configHud:(GTCurrentHud)configHud {
    GTProgressHUD *hud = settHUD(view, text, YES);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}


+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}


+ (void)hideHUD {
    [self hideHUDForView:nil];
}


#pragma mark -- sett // gett
- (void)didClickCancelButton {
    if (self.cancelation) {
        self.cancelation(self);
    }
}

@end




#pragma mark -- MBProgressHUD延展

@implementation MBProgressHUD(GTExtension)

- (void)setCancelation:(GTCancelation)cancelation {
    objc_setAssociatedObject(self, @selector(cancelation), cancelation, OBJC_ASSOCIATION_COPY);
}

- (GTCancelation)cancelation {
    return objc_getAssociatedObject(self, _cmd);
}

- (MBProgressHUD *(^)(UIColor *))hudBackgroundColor {
    return ^(UIColor *hudBackgroundColor) {
        self.backgroundView.color = hudBackgroundColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIView *))toView {
    return ^(UIView *view){
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))title {
    return ^(NSString *title){
        self.label.text = title;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))details {
    return ^(NSString *details){
        self.detailsLabel.text = details;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))customIcon {
    return ^(NSString *customIcon) {
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:customIcon]];
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))titleColor {
    return ^(UIColor *titleColor){
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))progressColor {
    return ^(UIColor *progressColor) {
        UIColor *titleColor = self.label.textColor;
        self.contentColor = progressColor;
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))allContentColors {
    return ^(UIColor *allContentColors) {
        self.contentColor = allContentColors;
        return self;
    };
}


- (MBProgressHUD *(^)(UIColor *))bezelBackgroundColor {
    return ^(UIColor *bezelViewColor){
        self.bezelView.backgroundColor = bezelViewColor;
        return self;
    };
}



- (MBProgressHUD *(^)(GTHUDContentStyle))hudContentStyle {
    return ^(GTHUDContentStyle hudContentStyle){
        if (hudContentStyle == GTHUDContentBlackStyle) {
            self.contentColor = [UIColor whiteColor];
            self.bezelView.backgroundColor = [UIColor blackColor];
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;

        } else if (hudContentStyle == GTHUDContentCustomStyle) {
            self.contentColor = GTCustomHudStyleContentColor;
            self.bezelView.backgroundColor = GTCustomHudStyleBackgrandColor;
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;

        } else if (hudContentStyle == GTHUDContentDefaultStyle){
            self.contentColor = [UIColor blackColor];
            self.bezelView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;

        }
        return self;
    };
}


- (MBProgressHUD *(^)(GTHUDPostion))hudPostion {
    return ^(GTHUDPostion hudPostion){
        if (hudPostion == GTHUDPostionTop) {
            self.offset = CGPointMake(0.f, -MBProgressMaxOffset);
        } else if (hudPostion == GTHUDPostionCenten) {
            self.offset = CGPointMake(0.f, 0.f);
        } else {
            self.offset = CGPointMake(0.f, MBProgressMaxOffset);
        }
        return self;
    };
}

- (MBProgressHUD *(^)(GTHUDProgressStyle))hudProgressStyle {
    return ^(GTHUDProgressStyle hudProgressStyle){
        if (hudProgressStyle == GTHUDProgressStyleDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;

        } else if (hudProgressStyle == GTHUDProgressStyleAnnularDeterminate) {
            self.mode = MBProgressHUDModeAnnularDeterminate;

        } else if (hudProgressStyle == GTHUDProgressStyleCancelationDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;

        } else if (hudProgressStyle == GTHUDProgressStyleDeterminateHorizontalBar) {
            self.mode = MBProgressHUDModeDeterminateHorizontalBar;

        }
        return self;
    };
}

@end

