//
//  JLRoutes+GenerateURL.h
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <JLRoutes/JLRoutes.h>
#import <UIKit/UIKit.h>

extern NSString *const JLRouterParameterCallBack;

@interface JLRoutes (GenerateURL)

/**
 避免 URL 散落各处， 集中生成URL

 @param pattern 匹配模式
 @param parameters 附带参数
 @return URL字符串
 */
+ (NSString *)gt_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters;

/**
 避免 URL 散落各处， 集中生成URL
 额外参数将被 ?key=value&key2=value2 样式给出

 @param pattern 匹配模式
 @param parameters 附加参数
 @param extraParameters 额外参数
 @return URL字符串
 */
+ (NSString *)gt_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters extraParameters:(NSDictionary *)extraParameters;

/**
 解析NSURL对象中的请求参数
 http://madao?param1=value1&param2=value2 解析成 @{param1:value1, param2:value2}
 @param URL NSURL对象
 @return URL字符串
 */
+ (NSDictionary *)gt_parseParamsWithURL:(NSURL *)URL;

/**
 将参数对象进行url编码
 将@{param1:value1, param2:value2} 转换成 ?param1=value1&param2=value2
 @param dic 参数对象
 @return URL字符串
 */
+ (NSString *)gt_mapDictionaryToURLQueryString:(NSDictionary *)dic;


/**
 打开路由

 @param URL URL地址
 */
+ (void)openURL:(NSURL *)URL;


/**
 打开路由

 @param URL URL地址
 @param parameters 参数
 @param callBack 回调
 @return 是否打开了路由
 */
+ (BOOL)routeURL:(NSURL *)URL withParameters:(NSMutableDictionary<NSString *,id> *)parameters callBack:(void (^)(id))callBack;

@end
