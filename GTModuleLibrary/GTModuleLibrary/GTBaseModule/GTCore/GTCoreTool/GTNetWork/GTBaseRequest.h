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
// 获取服务器响应状态信息 key
FOUNDATION_EXTERN NSString *const GT_BaseRequest_StatusMsgKey;
// 获取服务器响应数据 key
FOUNDATION_EXTERN NSString *const GT_BaseRequest_DataKey;
// 服务器响应数据成功状态码 value
FOUNDATION_EXTERN NSInteger const GT_BaseRequest_DataValue;

@class GTHTTPError;

@interface GTBaseRequest : YTKRequest

@property (nonatomic,strong) GTHTTPError * httpError;

- (BOOL)isHideErrorToast;

/**
 数据库请求成功后返回的data数据

 @return 返回  NSDictionary类型的 data 数据
 */
- (NSDictionary *)parsmDataValue;


/**
 数据库请求成功后返回的data数据

 @return 返回  json字符串类型的 data 数据
 */
- (NSString *)parsmDataValueWithJsonString;



#pragma mark - Override

/**
 自定义request参数

 @return dic
 */
- (NSDictionary *)reformParams;





@end
