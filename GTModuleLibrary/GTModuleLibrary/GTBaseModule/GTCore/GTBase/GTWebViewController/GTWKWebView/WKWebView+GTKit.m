//
//  WKWebView+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/10.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "WKWebView+GTKit.h"
#import "WeakScriptMessageDelegate.h"


@interface WKWebView ()

@property (nonatomic, assign) CGFloat webViewHeigt;

@end

@implementation WKWebView (GTKit)

#pragma mark - hook

/**
 添加 WKWebView 的代理，注意：用此方法添加代理，例如：
 BAKit_WeakSelf
 [self.webView gt_web_initWithDelegate:weak_self.webView uIDelegate:weak_self.webView];

 @param navigationDelegate navigationDelegate
 @param uIDelegate uIDelegate
 */
- (void)gt_web_initWithDelegate:(id<WKNavigationDelegate>)navigationDelegate uIDelegate:(id<WKUIDelegate>)uIDelegate {
    self.navigationDelegate = navigationDelegate;
    self.UIDelegate = uIDelegate;
    self.webViewHeigt = 0.f;
    [self gt_web_addNoti];
}

- (void)gt_web_dealloc
{
    [self gt_removeNoti];
}

- (void)gt_removeNoti
{
    [self removeObserver:self forKeyPath:kGTKit_WK_title];
    [self removeObserver:self forKeyPath:kGTKit_WK_estimatedProgress];
    [self removeObserver:self forKeyPath:kGTKit_WK_URL];
    if ( self.gt_web_isAutoHeight )
    {
        [self.scrollView removeObserver:self forKeyPath:kGTKit_WK_contentSize];
    }
}

#pragma mark - 添加对 WKWebView 属性的监听
- (void)gt_web_addNoti
{
    // 获取页面标题
    [self addObserver:self
           forKeyPath:kGTKit_WK_title
              options:NSKeyValueObservingOptionNew
              context:nil];

    // 当前页面载入进度
    [self addObserver:self
           forKeyPath:kGTKit_WK_estimatedProgress
              options:NSKeyValueObservingOptionNew
              context:nil];

    // 监听 URL，当之前的 URL 不为空，而新的 URL 为空时则表示进程被终止
    [self addObserver:self
           forKeyPath:kGTKit_WK_URL
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kGTKit_WK_title])
    {
        if (self.gt_web_getTitleBlock)
        {
            self.gt_web_getTitleBlock(self.title);
        }
        if (self.gt_web_getCurrentUrlBlock)
        {
            self.gt_web_getCurrentUrlBlock(self.URL);
        }
    }
    else if ([keyPath isEqualToString:kGTKit_WK_estimatedProgress])
    {
        if (self.gt_web_isLoadingBlock)
        {
            self.gt_web_isLoadingBlock(self.loading, self.estimatedProgress);
        }
    }
    else if ([keyPath isEqualToString:kGTKit_WK_URL])
    {
        NSURL *newUrl = [change objectForKey:NSKeyValueChangeNewKey];
        NSURL *oldUrl = [change objectForKey:NSKeyValueChangeOldKey];
        if (![newUrl isKindOfClass:[NSURL class]] && [oldUrl isKindOfClass:[NSURL class]]) {
            [self reload];
        };
    }
    else if ( [keyPath isEqualToString:kGTKit_WK_contentSize] && [object isEqual:self.scrollView] )
    {
        __block CGFloat height = floorf([change[NSKeyValueChangeNewKey] CGSizeValue].height);

        if ( height != self.webViewHeigt )
        {
            self.webViewHeigt = height;

            CGRect frame = self.frame;
            frame.size.height = height;
            self.frame = frame;

            if ( self.gt_web_getCurrentHeightBlock )
            {
                self.gt_web_getCurrentHeightBlock(height);
            }
        }
        else if ( height == self.webViewHeigt && height > 0.f )
        {

        }
    }

    // 加载完成
//    if (!self.loading)
//    {
//        if (self.gt_web_isLoadingBlock)
//        {
//            self.gt_web_isLoadingBlock(self.loading, 1.0F);
//        }
//    }
}

#ifndef NSFoundationVersionNumber_iOS_9_0
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0)
{
    NSLog(@"进程被终止 %@",webView.URL);
    [webView reload];
}
#else

#endif

#pragma mark - custom Mothed
- (BOOL)gt_externalAppRequiredToOpenURL:(NSURL *)url
{
    // 若需要限制只允许某些前缀的scheme通过请求，则取消下述注释，并在数组内添加自己需要放行的前缀
    //    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https",@"file"]];
    //    return ![validSchemes containsObject:URL.scheme];

    //    NSURL *responseUrl = navigationAction.request.URL;
    //    NSString *urlStr = [responseUrl absoluteString];
    //    if ([[responseUrl scheme] isEqualToString:baseUrlScheme]) {
    //        if ([urlStr containsString:baseShareUrlPath]) {
    //            //点击立即分享
    ////            [VPKCShare showShareWithPlatformImages:@[@"fx_pengyouquan"]];
    //            decisionHandler(WKNavigationActionPolicyCancel);
    //        } else if([responseUrl.path containsString:baseCloseUrlPath]){
    //            //点击关闭
    //            [_webView removeFromSuperview];
    //            decisionHandler(WKNavigationActionPolicyCancel);
    //        } else if([responseUrl.path containsString:baseGetUrlPath]){
    //            //点击立即领取
    //            decisionHandler(WKNavigationActionPolicyAllow);
    //        } else {
    //            decisionHandler(WKNavigationActionPolicyAllow);
    //        }
    //    } else {
    //        decisionHandler(WKNavigationActionPolicyAllow);
    //    }

    return !url;
}

#pragma mark - WKScriptMessageHandler
/**
 *  JS 调用 OC 时 webview 会调用此方法
 *
 *  @param userContentController  webview中配置的userContentController 信息
 *  @param message                JS执行传递的消息
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // 这里可以通过 name 处理多组交互
    // body 只支持 NSNumber, NSString, NSDate, NSArray,NSDictionary 和 NSNull 类型
    //    NSLog(@"JS 中 message Body ：%@",message.body);

    if (self.gt_web_userContentControllerDidReceiveScriptMessageBlock)
    {
    self.gt_web_userContentControllerDidReceiveScriptMessageBlock(userContentController, message);
    }
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame)
    {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark = WKNavigationDelegate
#pragma mark 这个代理方法表示当客户端收到服务器的响应头，根据 response 相关信息，可以决定这次跳转是否可以继续进行。在发送请求之前，决定是否跳转，如果不添加这个，那么 wkwebview 跳转不了 AppStore 和 打电话
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    //    NSLog(@"%@",hostname);
    NSURL *url = navigationAction.request.URL;
    NSString *url_string = url.absoluteString;
    NSString *url_scheme = url.scheme;
    //    NSString *url_query = url.query;
    //    NSString *url_host = url.host;

    //    NSLog(@"URL scheme:%@", url_scheme);
    //    NSLog(@"URL scheme2:%@", self.gt_web_urlScheme);
    //    NSLog(@"URL query: %@", url_query);

    if ([url_scheme isEqualToString:self.gt_web_urlScheme])
    {
        if (self.gt_web_decidePolicyForNavigationActionBlock)
        {
            self.gt_web_decidePolicyForNavigationActionBlock(url);
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // APPStore
    if ([url.absoluteString containsString:@"itunes.apple.com"])
    {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 调用电话
    if ([url.scheme isEqualToString:@"tel"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

    // 参数 WKNavigationAction 中有两个属性：sourceFrame 和 targetFrame，分别代表这个 action 的出处和目标，类型是 WKFrameInfo 。WKFrameInfo有一个 mainFrame 的属性，标记frame是在主frame里显示还是新开一个frame显示
    //    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    //    BOOL isMainframe = [frameInfo isMainFrame];
    //    NSLog(@"isMainframe :%d", isMainframe);

    if (![self gt_externalAppRequiredToOpenURL:url])
    {
        if (!navigationAction.targetFrame)
        {
            [self gt_web_loadURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    else if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }


    //拦截404或者网络错误点击重新加载时 加载有效地址
    if ([url_string hasSuffix:GT_404_NOT_FOUND_RELOAD_URL] || [url_string hasSuffix:GT_NET_ERROR_RELOAD_URL]) {
        //替换404/网络错误页面
        [self gt_web_stringByEvaluateJavaScript:[NSString stringWithFormat:@"window.location.replace('%@')", self.gt_web_effectiveUrl] completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    if ((![url_string hasSuffix:GT_NET_ERROR_HTML_PATH_String]) && (![url_string hasSuffix:GT_404_NOT_FOUND_HTML_PATH_String])) {
        self.gt_web_effectiveUrl = url_string;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - 在响应完成时，调用的方法。如果设置为不允许响应，web内 容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{

}

#pragma mark - WKNavigationDelegate
// 开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{

    if (self.gt_web_didStartBlock)
    {
        self.gt_web_didStartBlock(webView, navigation);
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
    if (self.gt_web_didCommitBlock)
    {
        self.gt_web_didCommitBlock(webView, navigation);
    }
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

    if (self.gt_web_didFinishBlock)
    {
        self.gt_web_didFinishBlock(webView, navigation);
    }

    NSString *heightString4 = @"document.body.scrollHeight";

    if (self.gt_web_getCurrentHeightBlock && !self.gt_web_isAutoHeight)
    {
        // webView 高度自适应
        [self gt_web_stringByEvaluateJavaScript:heightString4 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            // 获取页面高度，并重置 webview 的 frame
            // NSLog(@"html 的高度：%@", result);

            self.gt_web_getCurrentHeightBlock([result doubleValue]);

            //        CGRect frame = webView.frame;
            //        frame.size.height = currentHeight;
            //        webView.frame = frame;
            //        [webView.superview setNeedsLayout];
        }];
    }


}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (self.gt_web_didFailBlock) {
        self.gt_web_didFailBlock(webView, navigation, error);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
{
    if (self.gt_web_didFailBlock) {
        self.gt_web_didFailBlock(webView, navigation, error);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    // 如果出现频繁刷新的情况，说明页面占用内存确实过大，需要前端作优化处理
    if (GT_WK_isTreatMemeryCrushWithReload) {
        [self gt_web_reload]; // 解决内存消耗过度出现白屏的问题
    }
}


#pragma mark - Public method
/**
 *  返回上一级页面
 */
- (void)gt_web_goBack
{
    if (self.canGoBack)
    {
        [self goBack];
    }
}

/**
 *  进入下一级页面
 */
- (void)gt_web_goForward
{
    if (self.canGoForward)
    {
        [self goForward];
    }
}

/**
 *  跳转到某个指定历史页面
 */
- (void)gt_web_goToBackForwardListItem: (WKBackForwardListItem *)listItem
{
    [self goToBackForwardListItem:(listItem)];
}

/**
 *  刷新 webView
 */
- (void)gt_web_reload
{
    [self reload];
}

/**
 *  比较网络数据是否有变化，没有变化则使用缓存，否则从新请求。刷新 webView
 */
- (void)gt_web_reloadFromOrigin
{
    [self reloadFromOrigin];
}


/**
 *  加载一个 webview
 *
 *  @param request 请求的 NSURL URLRequest
 */
- (void)gt_web_loadRequest:(NSURLRequest *)request
{
    [self loadRequest:request];
}

/**
 *  加载一个 webview
 *
 *  @param URL 请求的 URL
 */
- (void)gt_web_loadURL:(NSURL *)URL
{
    [self gt_web_loadRequest:[NSURLRequest requestWithURL:URL]];
}

/**
 *  加载一个 webview
 *
 *  @param URLString 请求的 URLString
 */
- (void)gt_web_loadURLString:(NSString *)URLString
{
    [self gt_web_loadURL:[NSURL URLWithString:URLString]];
}

/**
 *  加载本地网页
 *
 *  @param htmlName 请求的本地 HTML 文件名
 */
- (void)gt_web_loadHTMLFileName:(NSString *)htmlName
{
    /*! 一定要记得这一步，要不然本地的图片加载不出来 */
    //    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    //    NSURL *baseURL = [NSURL fileURLWithPath:basePath];

    //    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlName
    //                                                         ofType:@"html"];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.html", htmlName] ofType:nil];

    //    NSString *HTMLString = [NSString stringWithContentsOfFile:htmlPath
    //                                                     encoding:NSUTF8StringEncoding
    //                                                        error:nil];
    [self gt_web_loadHTMLFilePath:htmlPath];
}

/**
 *  加载本地网页
 *
 *  @param htmlPath 请求的本地 HTML 路径
 */
- (void)gt_web_loadHTMLFilePath:(NSString *)htmlPath
{
    if (htmlPath)
    {
        if (@available(iOS 9.0, *))
        {
            NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
            [self loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
            NSURL *fileURL = [self gt_fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:htmlPath]];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self loadRequest:request];
        }
    }
}

/**
 *  加载本地 htmlString
 *
 *  @param htmlString 请求的本地 htmlString
 */
- (void)gt_web_loadHTMLString:(NSString *)htmlString
{
    /*! 一定要记得这一步，要不然本地的图片加载不出来 */
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];

    [self loadHTMLString:htmlString baseURL:baseURL];
}

/**
 *  加载 js 字符串
 *
 *  @param javaScriptString js 字符串
 */
- (void)gt_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler
{
    [self evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

/**
 添加 js 调用 OC，addScriptMessageHandler:name:有两个参数，第一个参数是 userContentController的代理对象，第二个参数是 JS 里发送 postMessage 的对象。添加一个脚本消息的处理器,同时需要在 JS 中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。

 @param nameArray JS 里发送 postMessage 的对象数组，可同时添加多个对象
 */
- (void)gt_web_addScriptMessageHandlerWithNameArray:(NSArray *)nameArray
{
    if ([nameArray isKindOfClass:[NSArray class]] && nameArray.count > 0)
    {
        [nameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:obj];
        }];
    }
}

// 将文件copy到tmp目录
- (NSURL *)gt_fileURLForBuggyWKWebView8:(NSURL *)fileURL
{
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];

    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

- (void)gt_web_shareNativeCookiesWithURL:(NSURL *)URL
{
    if (URL == nil) { return; }
    if (@available(iOS 11.0, *)) {
        NSHTTPCookieStorage *cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray<NSHTTPCookie *> *cookies = [cookiesStorage cookiesForURL:URL];
        NSArray *selfCookies = [cookies filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return ((NSHTTPCookie *)evaluatedObject).domain == URL.host;
        }]];

        WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
        for (NSHTTPCookie *cookie in selfCookies) {
            [dataStore.httpCookieStore setCookie:cookie completionHandler:nil];
        }
    }
}

- (void)gt_web_shareWebViewCookiesWithURL:(NSURL *)URL
{
    if (URL == nil) { return; }
    if (@available(iOS 11.0, *)) {
        WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
        [dataStore.httpCookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            NSArray<NSHTTPCookie *> *selfCookies = [cookies filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return ((NSHTTPCookie *)evaluatedObject).domain == URL.host;
            }]];

            NSHTTPCookieStorage *cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in selfCookies) {
                [cookiesStorage setCookie:cookie];
            }
        }];
    }
}


#pragma mark - setter / getter

+ (void)load
{
    //    BAKit_Objc_exchangeMethodAToB(NSSelectorFromString(@"init"), @selector(gt_web_init));
    //    BAKit_Objc_exchangeMethodAToB(NSSelectorFromString(@"initWithFrame"), @selector(gt_web_initWithFrame));
    SEL originalSelector = NSSelectorFromString(@"dealloc");
    SEL swizzledSelector = NSSelectorFromString(@"gt_web_dealloc");
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setWebViewHeigt:(CGFloat)webViewHeigt
{
    objc_setAssociatedObject(self, @selector(webViewHeigt), @(webViewHeigt), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)webViewHeigt
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setGt_web_isAutoHeight:(BOOL)gt_web_isAutoHeight
{
    objc_setAssociatedObject(self, @selector(gt_web_isAutoHeight), @(gt_web_isAutoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if ( gt_web_isAutoHeight )
    {
        // 监听高度变化
        [self.scrollView addObserver:self
                          forKeyPath:kGTKit_WK_contentSize
                             options:NSKeyValueObservingOptionNew
                             context:nil];
    }
}

- (BOOL)gt_web_isAutoHeight {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)gt_web_canGoBack
{
    return [self canGoBack];
}

- (BOOL)gt_web_canGoForward
{
    return [self canGoForward];
}

- (void)setGt_web_didStartBlock:(GTKit_webView_didStartProvisionalNavigationBlock)gt_web_didStartBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_didStartBlock), gt_web_didStartBlock, OBJC_ASSOCIATION_COPY);

}

- (GTKit_webView_didStartProvisionalNavigationBlock)gt_web_didStartBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_didCommitBlock:(GTKit_webView_didCommitNavigationBlock)gt_web_didCommitBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_didCommitBlock), gt_web_didCommitBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_didCommitNavigationBlock)gt_web_didCommitBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_didFinishBlock:(GTKit_webView_didFinishNavigationBlock)gt_web_didFinishBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_didFinishBlock), gt_web_didFinishBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_didFinishNavigationBlock)gt_web_didFinishBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_didFailBlock:(GTKit_webView_didFailProvisionalNavigationBlock)gt_web_didFailBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_didFailBlock), gt_web_didFailBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_didFailProvisionalNavigationBlock)gt_web_didFailBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_isLoadingBlock:(GTKit_webView_isLoadingBlock)gt_web_isLoadingBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_isLoadingBlock), gt_web_isLoadingBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_isLoadingBlock)gt_web_isLoadingBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_getTitleBlock:(GTKit_webView_getTitleBlock)gt_web_getTitleBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_getTitleBlock), gt_web_getTitleBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_getTitleBlock)gt_web_getTitleBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_userContentControllerDidReceiveScriptMessageBlock:(GTKit_webView_userContentControllerDidReceiveScriptMessageBlock)gt_web_userContentControllerDidReceiveScriptMessageBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_userContentControllerDidReceiveScriptMessageBlock), gt_web_userContentControllerDidReceiveScriptMessageBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_userContentControllerDidReceiveScriptMessageBlock)gt_web_userContentControllerDidReceiveScriptMessageBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_decidePolicyForNavigationActionBlock:(GTKit_webView_decidePolicyForNavigationActionBlock)gt_web_decidePolicyForNavigationActionBlock
{
       objc_setAssociatedObject(self, @selector(gt_web_decidePolicyForNavigationActionBlock), gt_web_decidePolicyForNavigationActionBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_decidePolicyForNavigationActionBlock)gt_web_decidePolicyForNavigationActionBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_getCurrentUrlBlock:(GTKit_webView_getCurrentUrlBlock)gt_web_getCurrentUrlBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_getCurrentUrlBlock), gt_web_getCurrentUrlBlock, OBJC_ASSOCIATION_COPY);
}

- (GTKit_webView_getCurrentUrlBlock)gt_web_getCurrentUrlBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_getCurrentHeightBlock:(GTKit_webView_getCurrentHeightBlock)gt_web_getCurrentHeightBlock
{
    objc_setAssociatedObject(self, @selector(gt_web_getCurrentHeightBlock), gt_web_getCurrentHeightBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GTKit_webView_getCurrentHeightBlock)gt_web_getCurrentHeightBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_urlScheme:(NSString *)gt_web_urlScheme
{
    objc_setAssociatedObject(self, @selector(gt_web_urlScheme), gt_web_urlScheme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)gt_web_urlScheme
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_web_effectiveUrl:(NSString *)gt_web_effectiveUrl
{
    objc_setAssociatedObject(self, @selector(gt_web_effectiveUrl), gt_web_effectiveUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)gt_web_effectiveUrl
{
    return objc_getAssociatedObject(self, _cmd);
}


@end
