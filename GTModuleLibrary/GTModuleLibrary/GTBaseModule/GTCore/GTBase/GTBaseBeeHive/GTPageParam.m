//
//  GTPageParam.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTPageParam.h"

@interface GTPageParam()
{
    NSDictionary *_params;
    GTPageCallback _callback;
}
@end

@implementation GTPageParam

- (instancetype)initWithPageParams:(NSDictionary *)params callback:(GTPageCallback)callback
{
    self = [super init];
    if (self) {
        _params = params;
        _callback = callback;
    }
    return self;
}

@end
