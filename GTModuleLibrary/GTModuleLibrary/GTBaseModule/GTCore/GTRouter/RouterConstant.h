//
//  RouterConstant.h
//  GTKit
//
//  Created by liuxc on 2018/5/29.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTBaseRequest.h"

@interface RouterConstant : NSObject

// 路由默认控制器参数名
FOUNDATION_EXTERN NSString *const ControllerNameRouteParam;

// 路由模块参数名
FOUNDATION_EXTERN NSString *const ModuleNameRouteParam;

#pragma mark - 路由模式 Schema
/**
 模式 Native：AppSchema://url/:param
 */
// 默认路由
FOUNDATION_EXTERN NSString *const DefaultRouteSchema;

// 网络跳转路由模式
FOUNDATION_EXTERN NSString *const HTTPRouteSchema;
FOUNDATION_EXTERN NSString *const HTTPsRouteSchema;

// WEB交互路由跳转模式
FOUNDATION_EXTERN NSString *const WebHandlerRouteSchema;

// 发起通信
FOUNDATION_EXTERN NSString *const ComponentsCallRouteSchema;

// 回调通信
FOUNDATION_EXTERN NSString *const ComponentsCallBackHandlerRouteSchema;

// 未知路由
FOUNDATION_EXTERN NSString *const UnknownHandlerRouteSchema;


#pragma mark - 路由表
// 导航栏 Push
FOUNDATION_EXTERN NSString *const NavPushRoute;

// 导航栏 Present
FOUNDATION_EXTERN NSString *const NavPresentRoute;

// StoryBoard Push
FOUNDATION_EXTERN NSString *const NavStoryBoardPushRoute;

// StoryBoard Present
FOUNDATION_EXTERN NSString *const NavStoryBoardPresentRoute;

// 切换Tabbar
FOUNDATION_EXTERN NSString *const NavTabbarIndexRoute;


// 组件通信回调
FOUNDATION_EXTERN NSString *const ComponentsCallBackRoute;



@end
