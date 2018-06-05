//
//  GTProgressHUDDefine.h
//  GTKit
//
//  Created by liuxc on 2018/5/8.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTProgressHUD.h"


typedef NS_ENUM(NSInteger, GTHUDContentStyle) {
    GTHUDContentDefaultStyle = 0,//默认是白底黑字 Default
    GTHUDContentBlackStyle = 1,//黑底白字
    GTHUDContentCustomStyle = 2,//:自定义风格<由自己设置自定义风格的颜色>
};

typedef NS_ENUM(NSInteger, GTHUDPostion) {
    GTHUDPostionTop,//上面
    GTHUDPostionCenten,//中间
    GTHUDPostionBottom,//下面
};

typedef NS_ENUM(NSInteger, GTHUDProgressStyle) {
    GTHUDProgressStyleDeterminate,//开扇型加载进度
    GTHUDProgressStyleDeterminateHorizontalBar,//横条加载进度
    GTHUDProgressStyleAnnularDeterminate,//环形加载进度
    GTHUDProgressStyleCancelationDeterminate//带取消按钮 - 开扇型加载进度
};

typedef void((^GTCancelation)(MBProgressHUD *hud));
typedef void((^GTCurrentHud)(MBProgressHUD *hud));

@interface MBProgressHUD (GTExtension)

@property (nonatomic, copy  ) GTCancelation cancelation;
///内容风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudContentStyle)(GTHUDContentStyle hudContentStyle);
///显示位置：有导航栏时在导航栏下在，无导航栏在状态栏下面
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudPostion)(GTHUDPostion hudPostion);
///进度条风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudProgressStyle)(GTHUDProgressStyle hudProgressStyle);
///标题
@property (nonatomic, copy  , readonly) MBProgressHUD *(^title)(NSString *title);
///详情
@property (nonatomic, copy  , readonly) MBProgressHUD *(^details)(NSString *details);
///自定义图片名
@property (nonatomic, copy  , readonly) MBProgressHUD *(^customIcon)(NSString *customIcon);
///标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^titleColor)(UIColor *titleColor);
///进度条颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^progressColor)(UIColor *progressColor);
///进度条、标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^allContentColors)(UIColor *allContentColors);
///蒙层背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^hudBackgroundColor)(UIColor *backgroundColor);
///内容背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^bezelBackgroundColor)(UIColor *bezelBackgroundColor);


@end
