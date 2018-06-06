//
//  UserInfoApi.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/6.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UserInfoApi.h"

@implementation UserInfoApi

- (NSString *)requestUrl {
    return @"/index/user/basic_info";
}

- (NSDictionary *)reformParams {
    return @{@"user_id": @5};
}

@end
