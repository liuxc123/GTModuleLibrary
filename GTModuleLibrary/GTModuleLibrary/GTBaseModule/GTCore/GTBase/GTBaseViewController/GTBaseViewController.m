//
//  GTBaseViewController.m
//  GTKit
//
//  Created by liuxc on 2018/3/24.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTBaseViewController.h"

@interface GTBaseViewController ()

@end

@implementation GTBaseViewController

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init]) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //默认背景颜色
    self.view.backgroundColor = [UIColor whiteColor];

    //配置默认样式
    [self configDefaultStyle];

    //配置navigationBar
    [self configNavi];

    //配置主题
    [self configTheme];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //清除缓存
}


- (void)didInitialized {

    //不自动留出空白
//    if (@available(iOS 11.0, *)){
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    // 不管navigationBar的backgroundImage如何设置，都让布局撑到屏幕顶部，方便布局的统一
    self.extendedLayoutIncludesOpaqueBars = YES;

    //配置当前页面设备旋转
    self.supportedOrientationMask = UIInterfaceOrientationMaskAll;
    
    // 动态字体notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeCategoryDidChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

#pragma mark - 配置默认样式
- (void)configDefaultStyle {
    //设置导航栏默认样式

}

#pragma mark - 设置横竖屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.supportedOrientationMask;
}

#pragma mark - 设置状态栏
- (BOOL)prefersStatusBarHidden {
    return self.gt_statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



#pragma mark - 自定义转场动画



#pragma mark - 属性set/get
#pragma mark loading加载页面/空页面
//- (GTLoadingView *)loadingView{
//    
//    if (!_loadingView) {
//        
//        __weak typeof(self) weakSelf = self;
//        _loadingView = [GTLoadingView loadingViewStyleCircleWithFrame:self.view.frame];
//        
//        [weakSelf.view addSubview:_loadingView];
//        
//        [weakSelf.view bringSubviewToFront:_loadingView];
//        
//    }
//    return _loadingView;
//}




@end


#pragma mark - 自定义方法(子类重写)
@implementation GTBaseViewController(SubClassHooks)

- (void)configNavi
{
    //子类重写
}

- (void)configTheme
{
    //子类重写
}

- (void)contentSizeCategoryDidChanged:(NSNotification *)notification {
    // 子类重写
}

- (void)layoutLoadingView
{
    //重新布局LoadingView 子类重写
}

@end
