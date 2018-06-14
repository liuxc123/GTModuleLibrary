//
//  UIScrollView+GTRefresh.m
//  GTKit
//
//  Created by liuxc on 2018/5/23.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIScrollView+GTRefresh.h"
#import <MJRefresh/MJRefresh.h>
#import "UniversalRefresh.h"

@implementation UIScrollView (GTRefresh)

- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock{
    
    if (headerBlock) {
        
        MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (headerBlock) {
                headerBlock();
            }
        }];
        self.mj_header = header;
    }
    if (footerBlock) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            footerBlock();
        }];
        self.mj_footer = footer;
    }

}

- (void)setRefreshWithHeaderType:(GTRefreshHeaderType)headerType
                     headerBlock:(void (^)(void))headerBlock
                      footerType:(GTRefreshFooterType)footerType
                     footerBlock:(void (^)(void))footerBlock
{
    if (headerBlock) {

        MJRefreshHeader *header;

        if (headerType == GTRefreshHeaderTypeNormal) {
            header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                if (headerBlock) {
                    headerBlock();
                }
            }];
        }

        if (headerType == GTRefreshHeaderTypeGIF) {
            header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                if (headerBlock) {
                    headerBlock();
                }
            }];
        }

        self.mj_header = header;
    }
    if (footerBlock) {

        MJRefreshFooter *footer;

        if (footerType == GTRefreshFooterTypeBackNormal) {
            footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }

        if (footerType == GTRefreshFooterTypeBackGIF) {
            footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }

        if (footerType == GTRefreshFooterTypeAutoNormal) {
            footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }
        if (footerType == GTRefreshFooterTypeAutoGIF) {
            footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }
        self.mj_footer = footer;
    }

}

- (void)headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

- (void)footerNoMoreData
{
    [self.mj_footer setState:MJRefreshStateNoMoreData];
}

- (void)endRefreshing:(BOOL)isNoMoreData
{
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
    if (isNoMoreData) {
        [self.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self.mj_footer endRefreshing];
    }
}

- (void)hideFooterRefresh{
    self.mj_footer.hidden = YES;
}


- (void)hideHeaderRefresh{
    self.mj_header.hidden = YES;
}

@end
