//
//  GTWebViewController.m
//  GTKit
//
//  Created by liuxc on 2018/3/24.
//  Copyright © 2018年 liuxc. All rights reserved.
//


#import "GTWebViewController.h"
#import "GTWKWebView.h"
#import "GTWebViewProgressView.h"
#import "GTAlert.h"

@interface GTWebViewController ()

@property(nonatomic, strong) WKWebViewConfiguration *webConfig;
@property(nonatomic, strong) GTWebViewProgressView *progressView;
@property(nonatomic, strong) NSURL *gt_web_currentUrl;
@property(nonatomic, assign) BOOL isLoading;


@end

@implementation GTWebViewController

#pragma mark - lift circle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

- (BOOL)willDealloc
{
    return NO;
}

- (void)dealloc
{
    [self.webView removeFromSuperview];
    [self.progressView removeFromSuperview];
    self.webView = nil;
    self.webConfig = nil;
    self.progressView = nil;
    self.gt_web_currentUrl = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initData {
    self.webView.hidden = NO;
    self.isLoading = NO;
    self.isNeedShareCookies = NO;
}

- (void)initSubviews {
    self.view.backgroundColor = [UIColor whiteColor];

//    self.automaticallyAdjustsScrollViewInsets = NO;

    [self configBackItem];
    [self configMenuItem];
    [self configDelegateBlock];
    [self configShareNativeCookies];
}


- (void)configDelegateBlock {
    __weak typeof(self) weakSelf = self;

    self.webView.gt_web_didStartBlock = ^(WKWebView * _Nullable webView, WKNavigation * _Nonnull navigation) {
        // 开始加载
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isLoading = YES;
    };

    self.webView.gt_web_didFinishBlock = ^(WKWebView * _Nonnull webView, WKNavigation * _Nonnull navigation) {
        // 加载完成
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isLoading = NO;
        [strongSelf configShareWebViewCookies];
    };


    self.webView.gt_web_didFailBlock = ^(WKWebView * _Nonnull webView, WKNavigation * _Nonnull navigation, NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isLoading = NO;
        //错误处理
        if (error.code == NSURLErrorCancelled) {
            return;
        }
        [strongSelf gt_web_didFailLoadWithError:error];
    };

    self.webView.gt_web_isLoadingBlock = ^(BOOL isLoading, CGFloat progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf.isLoading) { return; }
        [strongSelf.progressView setProgress:progress animated:YES];
    };

    self.webView.gt_web_getTitleBlock = ^(NSString *title) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 获取当前网页的 title
        strongSelf.title = title;
    };

    self.webView.gt_web_getCurrentUrlBlock = ^(NSURL * _Nonnull currentUrl) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //获取当前的URL
        strongSelf.gt_web_currentUrl = currentUrl;
    };

}

#pragma mark - 设置共享cookies
- (void)configShareNativeCookies {
    // 共享 Cookies
    if (_isNeedShareCookies) {
        if (@available(iOS 11.0, *)) {
            [self.webView gt_web_shareNativeCookiesWithURL:self.gt_web_currentUrl];
        }
    }
}

- (void)configShareWebViewCookies {
    // 共享 Cookies
    if (_isNeedShareCookies) {
        if (@available(iOS 11.0, *)) {
            [self.webView gt_web_shareWebViewCookiesWithURL:self.gt_web_currentUrl];
        }
    }
}

#pragma mark - 修改 navigator.userAgent
- (void)changeNavigatorUserAgent
{
    __weak typeof(self) weakSelf = self;
    [self.webView gt_web_stringByEvaluateJavaScript:@"navigator.userAgent" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        NSLog(@"old agent ----- :%@", result);
        NSString *userAgent = result;

        NSString *customAgent = @" native_iOS";
        if ([userAgent hasSuffix:customAgent])
        {
            NSLog(@"navigator.userAgent已经修改过了");
        }
        else
        {
            NSString *customUserAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@"%@", customAgent]]; // 这里加空格是为了好看
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            [[NSUserDefaults standardUserDefaults] synchronize];

            if (@available(iOS 9.0, *)) {
                [strongSelf.webView setCustomUserAgent:customUserAgent];
            }
            [strongSelf gt_reload];
        }

    }];
}

- (void)gt_reload
{
    [self.webView gt_web_reload];
//    [self changeNavigatorUserAgent];
}

/**
 *  加载一个 webview
 *
 *  @param request 请求的 NSURL URLRequest
 */
- (void)gt_web_loadRequest:(NSURLRequest *)request
{
    [self.webView gt_web_loadRequest:request];
}

/**
 *  加载一个 webview
 *
 *  @param URL 请求的 URL
 */
- (void)gt_web_loadURL:(NSURL *)URL
{
    [self.webView gt_web_loadURL:URL];
}

/**
 *  加载一个 webview
 *
 *  @param URLString 请求的 URLString
 */
- (void)gt_web_loadURLString:(NSString *)URLString
{
    [self.webView gt_web_loadURLString:URLString];
}

/**
 *  加载本地网页
 *
 *  @param htmlName 请求的本地 HTML 文件名
 */
- (void)gt_web_loadHTMLFileName:(NSString *)htmlName
{
    [self.webView gt_web_loadHTMLFileName:htmlName];
}

/**
 *  加载本地网页(自定义路径)
 *
 *  @param htmlPath 请求的本地 HTML 路径
 */
- (void)gt_web_loadHTMLFilePath:(NSString *)htmlPath
{
    [self.webView gt_web_loadHTMLFilePath:htmlPath];
}

/**
 *  加载本地 htmlString
 *
 *  @param htmlString 请求的本地 htmlString
 */
- (void)gt_web_loadHTMLString:(NSString *)htmlString
{
    [self.webView gt_web_loadHTMLString:htmlString];
}

/**
 *  加载 js 字符串，例如：高度自适应获取代码：
 // webView 高度自适应
 [self ba_web_stringByEvaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
 // 获取页面高度，并重置 webview 的 frame
 self.ba_web_currentHeight = [result doubleValue];
 CGRect frame = webView.frame;
 frame.size.height = self.ba_web_currentHeight;
 webView.frame = frame;
 }];
 *
 *  @param javaScriptString js 字符串
 */
- (void)gt_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self.webView gt_web_stringByEvaluateJavaScript:javaScriptString completionHandler:completionHandler];
}


- (void)gt_web_didFailLoadWithError:(NSError *)error{
    NSLog(@"ErrorCode: %ld", (long)error.code);
    switch (error.code) {
        case NSURLErrorCannotFindHost://404
            [self gt_web_loadHTMLFilePath:GT_404_NOT_FOUND_HTML_PATH];
            break;
        case NSURLErrorUnsupportedURL:
            break;
        default://网络错误
            [self gt_web_loadHTMLFilePath:GT_NET_ERROR_HTML_PATH];
            break;
    }
}

#pragma mark - custom Method

#pragma mark 导航栏的返回按钮
- (void)configBackItem {
    UIImage *backImage = [UIImage imageNamed:@"GTWKWebView.bundle/navigationbar_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTintColor:self.navigationController.navigationBar.tintColor];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];

    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = colseItem;
}

#pragma mark 导航栏的菜单按钮
- (void)configMenuItem {
    UIImage *menuImage = [UIImage imageNamed:@"GTWKWebView.bundle/navigationbar_more"];
    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *menuBtn = [[UIButton alloc] init];
    [menuBtn setTintColor:self.navigationController.navigationBar.tintColor];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn sizeToFit];

    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = menuItem;
}

#pragma mark 导航栏的关闭按钮
- (void)configColseItem
{
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
//    [colseBtn setTitleColor:self.gt_barTintColor forState:UIControlStateNormal];
    [colseBtn setTintColor:self.navigationController.navigationBar.tintColor];

    [colseBtn addTarget:self action:@selector(colseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];

    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];

    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

#pragma mark - 按钮点击事件
#pragma mark 返回按钮点击
- (void)backBtnAction:(UIButton *)sender
{
    if (self.webView.gt_web_canGoBack)
    {
        [self.webView gt_web_goBack];

        if (self.navigationItem.leftBarButtonItems.count == 1)
        {
            [self configColseItem];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark 菜单按钮点击
- (void)menuBtnAction:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;

    NSString *url_Str = self.gt_web_currentUrl.absoluteString;

    [GTAlert actionsheet].config
    .gt_Action(@"safari打开", ^{
        if (url_Str.length == 0) {
            [GTAlert alert].config.gt_Content(@"无法获取到当前 URL！").gt_Action(@"确定", nil).gt_Show();
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_Str] options:@{} completionHandler:nil];

    })
    .gt_Action(@"复制链接", ^{
        if (url_Str.length == 0) {
            [GTAlert alert].config.gt_Content(@"无法获取到当前 URL！").gt_Action(@"确定", nil).gt_Show();
            return;
        }
        [[UIPasteboard generalPasteboard] setString:url_Str];
        [GTAlert alert].config.gt_Content(@"亲爱的，已复制URL到粘贴板中！").gt_Action(@"确定", nil).gt_Show();
    })
    .gt_Action(@"分享", ^{

    })
    .gt_Action(@"刷新", ^{
        [weakSelf.webView gt_web_reloadFromOrigin];
    })
    .gt_CancelAction(@"取消", nil)
    .gt_Show();
}

#pragma mark 关闭按钮点击
- (void)colseBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGFloat naviHeight = self.gt_prefersNavigationBarHidden ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = self.gt_statusBarHidden ? 0 : CGRectGetMaxY([[UIApplication sharedApplication] statusBarFrame]);
    CGFloat maxY = MAX(naviHeight, statusBarHeight);
    self.webView.frame = CGRectMake(0, maxY, bounds.size.width, bounds.size.height - maxY);
    self.progressView.frame = CGRectMake(0, naviHeight, bounds.size.width, 2);
}

#pragma mark - setter / getter
- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        //  添加 WKWebView 的代理，注意：用此方法添加代理
        __weak typeof(self) weakSelf = self;
        [self.webView gt_web_initWithDelegate:weakSelf.webView uIDelegate:weakSelf.webView];
        //允许手势返回
        self.webView.allowsBackForwardNavigationGestures = YES;
        self.webView.gt_web_isAutoHeight = NO;
        //允许多指操作
        self.webView.multipleTouchEnabled = YES;
        self.webView.autoresizesSubviews = YES;

        [self.view addSubview:self.webView];

        //        [self changeNavigatorUserAgent];
    }
    return _webView;
}

- (WKWebViewConfiguration *)webConfig
{
    if (!_webConfig) {

        // 创建并配置WKWebView的相关参数
        // 1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
        // 2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
        // 3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。

        _webConfig = [[WKWebViewConfiguration alloc] init];
        _webConfig.allowsInlineMediaPlayback = YES;

        if (@available(iOS 9.0, *)) {
            _webConfig.allowsPictureInPictureMediaPlayback = YES;
        }

        // 通过 JS 与 webView 内容交互
        // 注入 JS 对象名称 senderModel，当 JS 通过 senderModel 来调用时，我们可以在WKScriptMessageHandler 代理中接收到
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        // [userContentController addScriptMessageHandler:self name:@"GTShare"];
        _webConfig.userContentController = userContentController;

        // 初始化偏好设置属性：preferences
        _webConfig.preferences = [WKPreferences new];
        // The minimum font size in points default is 0;
        _webConfig.preferences.minimumFontSize = 0;
        // 是否支持 JavaScript
        _webConfig.preferences.javaScriptEnabled = YES;
        // 不通过用户交互，是否可以打开窗口
        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    }
    return _webConfig;
}


- (GTWebViewProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [GTWebViewProgressView new];
        _progressView.progressBarColor = [UIColor blueColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)setGt_web_progressTintColor:(UIColor *)gt_web_progressTintColor
{
    _gt_web_progressTintColor = gt_web_progressTintColor;

    self.progressView.progressBarColor = gt_web_progressTintColor;
}

#pragma mark - 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end


