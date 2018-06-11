//
//  GTPageParam.h
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GTPageCallback)(NSDictionary *callbackParams);

@interface GTPageParam : NSObject

/// 初始化
- (instancetype)initWithPageParams:(NSDictionary *)params callback:(GTPageCallback)callback;

/// 参数
@property (nonatomic, strong, readonly) NSDictionary *params;

/// 回调
@property (nonatomic, copy, readonly) GTPageCallback callback;


@end
