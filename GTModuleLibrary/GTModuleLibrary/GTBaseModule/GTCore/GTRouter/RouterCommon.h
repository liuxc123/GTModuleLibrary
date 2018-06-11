//
//  RouterCommon.h
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//
//  路由通用方法

#import <Foundation/Foundation.h>
#import "GTCommon.h"

/**
 路由参数拼接

 @param schema schema
 @param path 地址
 @return 返回拼接好的连接 NSString
 */
GT_EXTERN NSString* GTRootRoute(NSString *schema, NSString *path);


/**
 路由参数拼接

 @param schema schema
 @param path 地址
 @return 返回拼接好的连接 NSURL
 */
GT_EXTERN NSURL* GTRootRouteURL(NSString *schema, NSString *path);

