//
//  UniversalRefresh.m
//  GTKit
//
//  Created by liuxc on 2018/5/9.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UniversalRefresh.h"

/**
 *  刷新中动画图片数组
 */
static NSArray *refreshingHeaderImageArray;
static NSArray *refreshingfooterImageArray;

/**
 默认的下拉刷新控件
 */
@implementation MJRefreshNormalHeader (UniversalRefresh)

- (instancetype)init
{
    self = [super init];

    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];

    //设置图片

    header.arrowView.image = [UIImage imageNamed:@"refresh"];

    // 设置文字
    [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];

    // 设置字体

    header.stateLabel.font = [UIFont systemFontOfSize:16.0f];

    // 设置颜色

    header.stateLabel.textColor = [UIColor grayColor];

    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;

    //设置菊花样式

    //    header.lee_theme
    //    .LeeAddCustomConfig(DAY , ^(MJRefreshNormalHeader *item){
    //
    //        item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //    })
    //    .LeeAddCustomConfig(NIGHT , ^(MJRefreshNormalHeader *item){
    //
    //        item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    //    });

    return (id)header;
}

@end




@implementation MJRefreshGifHeader (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        if (!refreshingHeaderImageArray) {
            
            NSMutableArray *imageArray = [NSMutableArray array];
            
            for (NSInteger i = 1; i < 32; i++) {
                
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_%.2ld.png" , i]];
                
                if (image) [imageArray addObject:image];
            }
            
            refreshingHeaderImageArray = [imageArray copy];
        }
        
        //设置动画图片
        
        self.gifView.image = refreshingHeaderImageArray.firstObject;
        
        [self setImages:refreshingHeaderImageArray duration:1.0f forState:MJRefreshStateRefreshing];
        
        // 设置文字
        [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
        [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];
        
        // 设置字体
        
        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];
        
        // 设置颜色
        
        self.stateLabel.textColor = [UIColor grayColor];
        
        // 设置Label左边距
        
        self.labelLeftInset = -30.0f;
        
        // 隐藏时间
        
        self.lastUpdatedTimeLabel.hidden = YES;
        
    }
    return self;
    
}

@end

@implementation MJRefreshBackNormalFooter (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    if (self) {

        //去除箭头图片
        self.arrowView.image = nil;

        // 设置文字
        [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
        [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];

        // 设置字体

        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];

        // 设置颜色

//        self.stateLabel.lee_theme.LeeConfigTextColor(common_font_color_4);

        //设置菊花样式

//        self.lee_theme
//        .LeeAddCustomConfig(DAY , ^(MJRefreshAutoNormalFooter *item){
//
//            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        })
//        .LeeAddCustomConfig(NIGHT , ^(MJRefreshAutoNormalFooter *item){
//
//            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//        });

    }
    return self;
}

@end

/**
 带动态图的上拉加载控件,下拉刷新控件自适应在页面内容下面
 */
@implementation MJRefreshBackGifFooter (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    if (self) {

        // 设置字体

        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];

        if (!refreshingfooterImageArray) {

            NSMutableArray *imageArray = [NSMutableArray array];

            for (NSInteger i = 1; i < 32; i++) {

                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_%.2ld.png" , i]];

                if (image) [imageArray addObject:image];
            }

            refreshingfooterImageArray = [imageArray copy];
        }

        //设置动画图片

        self.gifView.image = refreshingfooterImageArray.firstObject;

        [self setImages:refreshingHeaderImageArray duration:1.0f forState:MJRefreshStateRefreshing];

        // 设置文字
        [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
        [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];

        // 设置字体

        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];

        // 设置颜色

        self.stateLabel.textColor = [UIColor grayColor];

        // 设置Label左边距

        self.labelLeftInset = -30.0f;

    }
    return self;
}

@end



@implementation MJRefreshAutoNormalFooter (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    if (self) {

        // 设置文字

        [self setTitle:@"加载更多" forState:MJRefreshStateIdle];

        [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];

        [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];

        // 设置字体

        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];



        // 设置颜色

//        self.stateLabel.lee_theme.LeeConfigTextColor(common_font_color_4);


        // 设置菊花样式

//        self.lee_theme
//        .LeeAddCustomConfig(DAY , ^(MJRefreshAutoNormalFooter *item){
//
//            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        })
//        .LeeAddCustomConfig(NIGHT , ^(MJRefreshAutoNormalFooter *item){
//
//            item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//        });

    }
    return self;
}


@end

@implementation MJRefreshAutoGifFooter (UniversalRefresh)

- (instancetype)init
{
    self = [super init];
    if (self) {

        // 设置字体

        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];

        if (!refreshingfooterImageArray) {

            NSMutableArray *imageArray = [NSMutableArray array];

            for (NSInteger i = 1; i < 32; i++) {

                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing_%.2ld.png" , i]];

                if (image) [imageArray addObject:image];
            }

            refreshingfooterImageArray = [imageArray copy];
        }

        //设置动画图片

        self.gifView.image = refreshingfooterImageArray.firstObject;

        [self setImages:refreshingHeaderImageArray duration:1.0f forState:MJRefreshStateRefreshing];

        // 设置文字

        [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [self setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
        [self setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];

        // 设置字体

        self.stateLabel.font = [UIFont systemFontOfSize:14.0f];

        // 设置颜色

        self.stateLabel.textColor = [UIColor grayColor];

        // 设置Label左边距

        self.labelLeftInset = -30.0f;

    }
    return self;
}

@end

