//
//  UniversalRefresh.h
//  GTKit
//
//  Created by liuxc on 2018/5/9.
//  Copyright © 2018年 liuxc. All rights reserved.
//
// 通用刷新样式定制

#import <MJRefresh/MJRefresh.h>


/**
  默认的下拉刷新控件
 */
@interface MJRefreshNormalHeader (UniversalRefresh)

@end


/**
 带动态图的下拉刷新控件
 */
@interface MJRefreshGifHeader (UniversalRefresh)

@end

/**
 默认的上拉刷新控件,下拉刷新控件自适应在页面内容下面
 */
@interface MJRefreshBackNormalFooter (UniversalRefresh)

@end

/**
 带动态图的上拉加载控件,下拉刷新控件自适应在页面内容下面
 */
@interface MJRefreshBackGifFooter (UniversalRefresh)

@end

/**
 默认的上拉动画刷新控件,下拉刷新控件一直在屏幕底部
 */
@interface MJRefreshAutoNormalFooter (UniversalRefresh)

@end

/**
 默认的上拉刷新控件,下拉刷新控件一直在屏幕底部
 */
@interface MJRefreshAutoGifFooter (UniversalRefresh)

@end




