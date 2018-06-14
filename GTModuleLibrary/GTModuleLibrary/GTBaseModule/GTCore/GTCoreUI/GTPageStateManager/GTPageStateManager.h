//
//  GTPageStateManager.h
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, GTPageStateType) {
    GTPageStateTypeNone = 0,
    GTPageStateTypeLoading,
    GTPageStateTypeEmpty,
    GTPageStateTypeNetworkError
};


typedef void(^ClickBlock)(void);

@interface GTPageStateManager : NSObject

@property (nonatomic, assign) GTPageStateType pageStateType;

@property (nonatomic, strong) NSString *emptyDataText;              // 空数据显示内容
@property (nonatomic, strong) NSString *emptyDataDescription;       // 空数据显示详情
@property (nonatomic, strong) UIImage  *emptyDataImage;             // 空数据的图片
@property (nonatomic, strong) NSString *emptyBtnTitle;              // 空数据按钮文字
@property (nonatomic, assign) CGFloat  emptyDataOffset;             // 垂直偏移量
@property (nonatomic, assign) ClickBlock emptyDataClickBlock;       // 空白点击事件
@property (nonatomic, assign) ClickBlock emptyDataButtonClickBlock; // 按钮点击事件


@property (nonatomic, strong) NSString *loadingPrompt;              // 加载中提示语
@property (nonatomic, strong) UIImage  *loadingImage;               // 加载中图片
@property (nonatomic, assign) CGFloat  loadingOffset;               // 垂直偏移量

@property (nonatomic, strong) NSString *networkErrorPrompt;         // 网络错误重新加载提示语
@property (nonatomic, strong) UIImage  *networkErrorImage;          // 网络错误重新加载图片
@property (nonatomic, strong) NSString *networkErrorBtnTitle;       // 网络错误重新加载按钮提示语
@property (nonatomic, assign) CGFloat  networkErrorOffset;          // 垂直偏移量
@property (nonatomic, assign) ClickBlock networkErrorClickBlock;    // 点击事件
@property (nonatomic, assign) ClickBlock networkErrorButtonClickBlock;  // 按钮点击事件



@end
