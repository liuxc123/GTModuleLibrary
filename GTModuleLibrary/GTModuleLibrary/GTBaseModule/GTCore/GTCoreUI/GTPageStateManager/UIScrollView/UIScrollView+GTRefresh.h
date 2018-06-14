//
//  UIScrollView+GTRefresh.h
//  GTKit
//
//  Created by liuxc on 2018/5/23.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Header类型

 - GTRefreshHeaderTypeNormal: 默认的下拉刷新
 - GTRefreshHeaderTypeGIF: 带Gif图片的下拉刷新
 */
typedef NS_ENUM(NSUInteger, GTRefreshHeaderType) {
    GTRefreshHeaderTypeNormal = 0,
    GTRefreshHeaderTypeGIF
};


/**
 Footer类型

 - GTRefreshFooterTypeBackNormal: 默认的上拉刷新，下拉刷新控件自适应在页面内容下面
 - GTRefreshFooterTypeBackGIF: 带动态图的上拉加载控件，下拉刷新控件自适应在页面内容下面
 - GTRefreshFooterTypeAutoNormal: 默认的上拉刷新控件，下拉刷新控件一直在屏幕底部
 - GTRefreshFooterTypeAutoGif: 默认的上拉动画刷新控件， 下拉刷新控件一直在屏幕底部
 */
typedef NS_ENUM(NSUInteger, GTRefreshFooterType) {
    GTRefreshFooterTypeBackNormal = 0,
    GTRefreshFooterTypeBackGIF,
    GTRefreshFooterTypeAutoNormal,
    GTRefreshFooterTypeAutoGIF
};

@interface UIScrollView (GTRefresh)


/**
 设置默认的刷新控件

 @param headerBlock 下拉刷新回调
 @param footerBlock 上拉刷新回调
 */
- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock;


/**
  设置刷新控件

 @param headerType header类型
 @param headerBlock 下拉刷新回调
 @param footerType footer类型
 @param footerBlock 上拉刷新回调
 */
- (void)setRefreshWithHeaderType:(GTRefreshHeaderType)headerType headerBlock:(void (^)(void))headerBlock footerType:(GTRefreshFooterType)footerType footerBlock:(void (^)(void))footerBlock;


- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;
- (void)footerEndRefreshing;
- (void)footerNoMoreData;
- (void)endRefreshing:(BOOL)isNoMoreData;

- (void)hideHeaderRefresh;
- (void)hideFooterRefresh;

@end



