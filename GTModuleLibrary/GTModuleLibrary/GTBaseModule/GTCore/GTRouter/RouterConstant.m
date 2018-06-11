//
//  RouterConstant.m
//  GTKit
//
//  Created by liuxc on 2018/5/29.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "RouterConstant.h"

@implementation RouterConstant

#pragma mark - 路由Controller参数
NSString *const ControllerNameRouteParam = @"viewController";

#pragma mark - 路由模式
NSString *const DefaultRouteSchema = @"GTModuleLibrary";
NSString *const HTTPRouteSchema = @"http";
NSString *const HTTPsRouteSchema = @"https";

NSString *const ComponentsCallBackHandlerRouteSchema = @"AppCallBack";
NSString *const ComponentsCallRouteSchema = @"mainapp";

NSString *const WebHandlerRouteSchema = @"Custom";
NSString *const UnknownHandlerRouteSchema = @"UnKnown";

#pragma mark - 路由表
NSString *const NavPushRoute = @"/com_navPush/:viewController";
NSString *const NavPresentRoute = @"/com_navPresent/:viewController";
NSString *const NavStoryBoardPushRoute = @"/com_navStoryboardPush/:viewController";
NSString *const NavStoryBoardPresentRoute = @"/com_navStoryboardPresent/:viewController";
NSString *const NavTabbarIndexRoute = @"/com_navTabbarIndex/:viewController";


NSString *const ComponentsCallBackRoute = @"/com_callBack/*";

@end
