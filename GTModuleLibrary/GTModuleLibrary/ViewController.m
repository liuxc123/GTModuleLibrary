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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GTWebViewController *vc = [[GTWebViewController alloc] init];
        [vc gt_web_loadURLString:@"http://www.baidu.com"];
        [self.navigationController pushViewController:vc animated:YES];
    });


    [GTAlert alert].config.gt_Title(@"提示").gt_Content(@"内容").gt_Action(@"确定", ^{
    }).gt_CancelAction(@"取消", nil).gt_Show();

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
