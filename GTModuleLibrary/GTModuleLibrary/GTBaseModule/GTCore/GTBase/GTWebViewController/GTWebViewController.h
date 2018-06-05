//
//  GTWebViewController.h
//  GTKit
//
//  Created by liuxc on 2018/3/24.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "GTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTWebViewController : GTBaseViewController

@property(nonatomic, strong) WKWebView * _Nullable webView;
@property(nonatomic, strong) UIColor * _Nullable gt_web_progressTintColor;

/**
 是否需要共享cookies
 */
@property(nonatomic, assign) BOOL isNeedShareCookies;
/**
 *  加载一个 webview
 *
 *  @param request 请求的 NSURL URLRequest
 */
- (void)gt_web_loadRequest:(NSURLRequest *)request;

/**
 *  加载一个 webview
 *
 *  @param URL 请求的 URL
 */
- (void)gt_web_loadURL:(NSURL *)URL;

/**
 *  加载一个 webview
 *
 *  @param URLString 请求的 URLString
 */
- (void)gt_web_loadURLString:(NSString *)URLString;

/**
 *  加载本地网页
 *
 *  @param htmlName 请求的本地 HTML 文件名
 */
- (void)gt_web_loadHTMLFileName:(NSString *)htmlName;

/**
 *  加载本地 htmlString
 *
 *  @param htmlString 请求的本地 htmlString
 */
- (void)gt_web_loadHTMLString:(NSString *)htmlString;


/**
 *  加载本地网页(自定义路径)
 *
 *  @param htmlPath 请求的本地 HTML 路径
 */
- (void)gt_web_loadHTMLFilePath:(NSString *)htmlPath;

/**
 *  加载 js 字符串，例如：高度自适应获取代码：
 // webView 高度自适应
 [self gt_web_stringByEvaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
 // 获取页面高度，并重置 webview 的 frame
 self.gt_web_currentHeight = [result doubleValue];
 CGRect frame = webView.frame;
 frame.size.height = self.gt_web_currentHeight;
 webView.frame = frame;
 }];
 *
 *  @param javaScriptString js 字符串
 */
- (void)gt_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END

