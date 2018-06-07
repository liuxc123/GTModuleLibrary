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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UserInfoApi *api = [[UserInfoApi alloc] init];

    api.animatingText = @"加载中";
    api.animatingView = self.view;

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"jsonDic = %@", [api parsmDataValue]);
        NSLog(@"jsonString = %@", [api parsmDataValueWithJsonString]);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"failed");
    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
