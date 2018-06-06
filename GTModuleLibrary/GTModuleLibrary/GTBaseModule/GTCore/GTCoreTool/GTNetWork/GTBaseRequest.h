//
//  GTBaseRequest.h
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/5.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "YTKBaseRequest+AnimatingAccessory.h"

// 获取服务器响应状态码 key
FOUNDATION_EXTERN NSString *const GT_BaseRequest_StatusCodeKey;
// 服务器响应数据成功状态码 value
FOUNDATION_EXTERN NSString *const GT_BaseRequest_DataValueKey;
// 获取服务器响应状态信息 key
FOUNDATION_EXTERN NSString *const GT_BaseRequest_StatusMsgKey;
// 获取服务器响应数据 key
FOUNDATION_EXTERN NSString *const GT_BaseRequest_DataKey;

@class GTHTTPError;

@interface GTBaseRequest : YTKRequest

@property (nonatomic,strong) GTHTTPError * httpError;

- (BOOL)isHideErrorToast;

#pragma mark - Override

/**
 自定义解析器解析响应参数

 @param jsonResponse json响应
 @return 解析后的json
 */
- (id)reformJSONResponse:(id)jsonResponse;

@end
