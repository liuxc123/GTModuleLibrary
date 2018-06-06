//
//  GTHTTPError.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/6.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTHTTPError.h"

@implementation GTHTTPError

- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary *)dict
{
    self = [super initWithDomain:domain code:code userInfo:dict];
    if (self) {
    }
    return self;
}





@end
