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
#import "GTMacros.h"
#import "GTProgressHUD.h"
#import "GTCategory.h"

// 获取服务器响应状态码 key
NSString *const GT_BaseRequest_StatusCodeKey = @"code";
// 获取服务器响应状态信息 key
NSString *const GT_BaseRequest_StatusMsgKey = @"desc";
// 获取服务器响应数据 key
NSString *const GT_BaseRequest_DataKey = @"data";
// 服务器响应数据成功状态码 value
NSInteger const GT_BaseRequest_DataValue = 0;

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

#pragma mark - Override
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}

//缓存时间<使用默认的start，在缓存周期内并没有真正发起请求>
- (NSInteger)cacheTimeInSeconds
{
    return 60;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 10.f;
}


- (NSString *)requestUrl
{
    // “ http://www.yuantiku.com ” 在 YTKNetworkConfig 中设置，这里只填除去域名剩余的网址信息
    return @"";
}

- (id)requestArgument
{
    return [[[self reformParams] gt_jsonString] gt_base64EncodedString];
}

- (void)start
{
    [super start];
}

- (void)stop
{
    [super stop];
}


//以下四个方法子类可以原始拥有，也可以`[super requestCompletePreprocessor];`进行基础上编写，也可以直接重写。但是一般情况下建议继承的基础上
//请求成功
- (void)requestCompletePreprocessor
{
    [super requestCompletePreprocessor];
    //json转model
}

//请求成功过滤
- (void)requestCompleteFilter
{
    [super requestCompleteFilter];
}

- (void)requestFailedPreprocessor
{
    [super requestFailedPreprocessor];
    //可以在此方法内处理token失效的情况，所有http请求统一走此方法，即会统一调用

    //如果部分服务端的失败以成功的方式返回给客户端，那么可以重写- (void)setCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success
    //failure:(nullable YTKRequestCompletionBlock)failure 方法，不过这个时候如果程序中有用到代理的话代理也要重写

    //note：子类如需继承，必须必须调用 [super requestFailedPreprocessor];
    NSError *error = self.error;

    if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
        //AFNetworking处理过的错误

    } else if ([error.domain isEqualToString:YTKRequestValidationErrorDomain]) {
        //猿题库处理过的错误
    } else {
        //系统级别的domain错误，无网络等[NSURLErrorDomain]
        //根据error的code去定义显示的信息，保证显示的内容可以便捷的控制
    }
    self.httpError = [[GTHTTPError alloc] initWithDomain:self.error.domain code:self.error.code userInfo:[self.error.userInfo copy]];

    if (![self isHideErrorToast]) {
        [GTProgressHUD showMessage:self.error.localizedDescription];
    }
}

//请求失败过滤
- (void)requestFailedFilter
{
    [super requestFailedPreprocessor];
}

// 验证状态码
- (BOOL)statusCodeValidator
{
    NSDictionary *responseDict = [super responseJSONObject];
    // 验证服务端返回验证码
    NSInteger stCode = kDecodeNumberFromDic(responseDict, GT_BaseRequest_StatusCodeKey).integerValue;
    if (stCode == GT_BaseRequest_DataValue) {
        // 请求成功
        return YES;
    }else{
        // 请求失败
        return NO;
    }
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"User-Agent": @"APP,,iPhone,Simulator,iOS 11.3,2.2.2,,,Wifi,14,App Store,414*736,2.2",
             @"user-id": @"5"};
}

/**
 数据库请求成功后返回的data数据

 @return 返回  NSDictionary类型的 data 数据
 */
- (NSDictionary *)parsmDataValue {
    NSDictionary *dic = [[self parsmDataValueWithJsonString] gt_dictionaryValue];
    return dic ?: @{};
}


/**
 数据库请求成功后返回的data数据

 @return 返回  json字符串类型的 data 数据
 */
- (NSString *)parsmDataValueWithJsonString {
    NSString *dataJsonString = [kDecodeStringFromDic(self.responseObject, GT_BaseRequest_DataKey) gt_base64DecodedString];
    return dataJsonString ?: @"";
}


- (id)parsmDataModel {
    return nil;
}


#pragma mark - Subclass Ovrride
- (NSDictionary *)reformParams
{
    return @{};
}




@end
  
