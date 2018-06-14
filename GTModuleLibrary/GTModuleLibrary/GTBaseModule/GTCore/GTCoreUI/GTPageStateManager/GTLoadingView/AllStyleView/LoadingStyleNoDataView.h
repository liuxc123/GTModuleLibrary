//
//  LoadingStyleNoDataView.h
//  GTKit
//
//  Created by liuxc on 2018/5/8.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingStyleNoDataView : UIView

@property (nonatomic , assign ) id target;

@property (nonatomic , assign ) SEL action;

@property (nonatomic , copy ) NSString *title;//标题文字

@end
