//
//  WKWebView+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/10.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <objc/runtime.h>


NS_ASSUME_NONNULL_BEGIN

#define kGTKit_WK_title                     @"title"
#define kGTKit_WK_estimatedProgress         @"estimatedProgress"
#define kGTKit_WK_URL                       @"URL"
#define kGTKit_WK_contentSize               @"contentSize"

#define GT_NET_ERROR_RELOAD_URL             @"gt_wk_network_error"
#define GT_404_NOT_FOUND_RELOAD_URL         @"gt_wk_404_not_found"

#define GT_NET_ERROR_HTML_PATH_String       @"/GTWKWebView.bundle/html.bundle/neterror.html"
#define GT_404_NOT_FOUND_HTML_PATH_String   @"/GTWKWebView.bundle/html.bundle/404.html"
#define GT_NET_ERROR_HTML_PATH              [[NSBundle mainBundle] pathForResource:@"html.bundle/neterror" ofType:@"html"]
#define GT_404_NOT_FOUND_HTML_PATH          [[NSBundle mainBundle] pathForResource:@"html.bundle/404" ofType:@"html"]

// 是否使用reload的方式处理内存占用过大造成的白屏问题
// 当打开的时候如果某个页面出现频繁刷新的情况，建议优化网页
#define GT_WK_isTreatMemeryCrushWithReload    NO


/**
 开始加载时调用

 @param webView webView
 @param navigation navigation
 */
typedef void (^GTKit_webView_didStartProvisionalNavigationBlock)(WKWebView * _Nullable webView, WKNavigation *navigation);

/**
 当内容开始返回时调用

 @param webView webView
 @param navigation navigation
 */
typedef void (^GTKit_webView_didCommitNavigationBlock)(WKWebView *webView, WKNavigation *navigation);

/**
 页面加载完成之后调用

 @param webView webView
 @param navigation navigation
 */
typedef void (^GTKit_webView_didFinishNavigationBlock)(WKWebView *webView, WKNavigation *navigation);

/**
 页面加载失败时调用

 @param webView webView
 @param navigation navigation
 */
typedef void (^GTKit_webView_didFailProvisionalNavigationBlock)(WKWebView *webView, WKNavigation *navigation, NSError *error);

/**
 获取 webview 当前的加载进度，判断是否正在加载

 @param isLoading 是否正在加载
 @param progress web 加载进度，范围：0.0f ~ 1.0f
 */
typedef void (^GTKit_webView_isLoadingBlock)(BOOL isLoading, CGFloat progress);

/**
 获取 webview 当前的 title

 @param title title
 */
typedef void (^GTKit_webView_getTitleBlock)(NSString *title);

/**
 JS 调用 OC 时 webview 会调用此方法

 @param userContentController webview中配置的userContentController 信息

 @param message JS执行传递的消息
 */
typedef void (^GTKit_webView_userContentControllerDidReceiveScriptMessageBlock)(WKUserContentController *userContentController, WKScriptMessage *message);

/**
 在发送请求之前，决定是否跳转，如果不添加这个，那么 wkwebview 跳转不了 AppStore 和 打电话，所谓拦截 URL 进行进一步处理，就在这里处理

 @param currentUrl currentUrl
 */
typedef void (^GTKit_webView_decidePolicyForNavigationActionBlock)(NSURL *currentUrl);

/**
 获取 webview 当前的 URL

 @param currentUrl currentUrl
 */
typedef void (^GTKit_webView_getCurrentUrlBlock)(NSURL *currentUrl);

/**
 获取 webview 当前的 currentHeight

 @param currentHeight currentHeight
 */
typedef void (^GTKit_webView_getCurrentHeightBlock)(CGFloat currentHeight);



@interface WKWebView (GTKit)
<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler
>


/**
 是否可以返回上级页面
 */
@property (nonatomic, readonly) BOOL gt_web_canGoBack;

/**
 是否可以进入下级页面
 */
@property (nonatomic, readonly) BOOL gt_web_canGoForward;

/**
 需要拦截的 urlScheme，先设置此项，再 调用 gt_web_decidePolicyForNavigationActionBlock 来处理，详见 demo
 */
@property(nonatomic, strong) NSString *gt_web_urlScheme;

/**
 是否需要自动设定高度
 */
@property (nonatomic, assign) BOOL gt_web_isAutoHeight;

/**
 有效地址(最近的一个有效地址)
 */
@property (nonatomic, strong) NSString *gt_web_effectiveUrl;

@property(nonatomic, copy) GTKit_webView_didStartProvisionalNavigationBlock gt_web_didStartBlock;
@property(nonatomic, copy) GTKit_webView_didCommitNavigationBlock gt_web_didCommitBlock;
@property(nonatomic, copy) GTKit_webView_didFinishNavigationBlock gt_web_didFinishBlock;
@property(nonatomic, copy) GTKit_webView_didFailProvisionalNavigationBlock gt_web_didFailBlock;
@property(nonatomic, copy) GTKit_webView_isLoadingBlock gt_web_isLoadingBlock;
@property(nonatomic, copy) GTKit_webView_getTitleBlock gt_web_getTitleBlock;
@property(nonatomic, copy) GTKit_webView_userContentControllerDidReceiveScriptMessageBlock gt_web_userContentControllerDidReceiveScriptMessageBlock;
@property(nonatomic, copy) GTKit_webView_decidePolicyForNavigationActionBlock gt_web_decidePolicyForNavigationActionBlock;
@property(nonatomic, copy) GTKit_webView_getCurrentUrlBlock gt_web_getCurrentUrlBlock;
@property(nonatomic, copy) GTKit_webView_getCurrentHeightBlock gt_web_getCurrentHeightBlock;

#pragma mark - Public method

/**
 添加 WKWebView 的代理，注意：用此方法添加代理，例如：
 GTKit_WeakSelf
 [self.webView gt_web_initWithDelegate:weak_self.webView uIDelegate:weak_self.webView];

 @param navigationDelegate navigationDelegate
 @param uIDelegate uIDelegate
 */
- (void)gt_web_initWithDelegate:(id<WKNavigationDelegate>)navigationDelegate
                     uIDelegate:(id<WKUIDelegate>)uIDelegate;

/**
 *  返回上一级页面
 */
- (void)gt_web_goBack;


/**
 *  进入下一级页面
 */
- (void)gt_web_goForward;

/**
 *  跳转到某个指定历史页面
 */
- (void)gt_web_goToBackForwardListItem: (WKBackForwardListItem *)listItem;

/**
 *  刷新 webView
 */
- (void)gt_web_reload;

/**
 *  比较网络数据是否有变化，没有变化则使用缓存，否则从新请求。刷新 webView
 */
- (void)gt_web_reloadFromOrigin;

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
 *  加载本地网页
 *
 *  @param htmlPath 请求的本地 HTML 路径
 */
- (void)gt_web_loadHTMLFilePath:(NSString *)htmlPath;

/**
 *  加载本地 htmlString
 *
 *  @param htmlString 请求的本地 htmlString
 */
- (void)gt_web_loadHTMLString:(NSString *)htmlString;

/**
 *  OC 调用 JS，加载 js 字符串，例如：高度自适应获取代码：
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
- (void)gt_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler;

/**
 JS 调用 OC，addScriptMessageHandler:name:有两个参数，第一个参数是 userContentController的代理对象，第二个参数是 JS 里发送 postMessage 的对象。添加一个脚本消息的处理器,同时需要在 JS 中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。

 @param nameArray JS 里发送 postMessage 的对象数组，可同时添加多个对象
 */
- (void)gt_web_addScriptMessageHandlerWithNameArray:(NSArray *)nameArray;



/**
 将 HTTPCookieStorage 中的 Cookies 同步到 WKWebsiteDataStore 中

 @param URL 链接
 */
- (void)gt_web_shareNativeCookiesWithURL:(NSURL *)URL;


/**
 将 WKWebsiteDataStore 中的 Cookies 同步到 HTTPCookieStorage 中

 @param URL 链接
 */
- (void)gt_web_shareWebViewCookiesWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
