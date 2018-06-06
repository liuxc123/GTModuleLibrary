//
//  GTBaseRequest.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/5.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTBaseRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "GTHTTPError.h"

// 获取服务器响应状态码 key
NSString *const GT_BaseRequest_StatusCodeKey = @"statusCode";
// 服务器响应数据成功状态码 value
NSString *const GT_BaseRequest_DataValueKey = @"0000";
// 获取服务器响应状态信息 key
NSString *const GT_BaseRequest_StatusMsgKey = @"statusMsg";
// 获取服务器响应数据 key
NSString *const GT_BaseRequest_DataKey = @"data";;

@implementation GTBaseRequest

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    self.animatingText = @"";
}

- (BOOL)isHideErrorToast
{
    return NO;
}




#pragma mark - Subclass Ovrride
- (id)reformJSONResponse:(id)jsonResponse
{
    return jsonResponse;
}

@end
  
