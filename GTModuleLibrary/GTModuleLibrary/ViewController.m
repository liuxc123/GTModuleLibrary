//
//  ViewController.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/5.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "ViewController.h"
#import "GTFunctionCommon.h"
#import "GTModuleLibrary-Swift.h"

#import "GTLoadingView.h"
@interface ViewController ()

@property (nonatomic, strong) GTLoadingView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.loadingView];


//    [self.loadingView showLoadingText:@"加载中"];

    [self.loadingView showLoadingProgressWithText:@"加载中"];

//    [self.loadingView showLoadingText:@"加载中"];

//    [self.loadingView showLoadingPromptBarWithText:@"测试" AutoHideTime:0.3];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    UserInfoApi *api = [[UserInfoApi alloc] init];
//
//    api.animatingText = @"加载中";
//    api.animatingView = self.view;
//
//    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"jsonDic = %@", [api parsmDataValue]);
//        NSLog(@"jsonString = %@", [api parsmDataValueWithJsonString]);
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"failed");
//    }];




}


static GTLoadingView * extracted() {
    return [[GTLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds LoadingViewStyle:LoadingViewStyleCircle];
}

- (GTLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = extracted();
    }
    return _loadingView;
}



@end
