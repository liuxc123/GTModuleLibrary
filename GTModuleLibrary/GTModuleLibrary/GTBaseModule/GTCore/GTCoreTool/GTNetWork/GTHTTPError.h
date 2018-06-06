//
//  GTHTTPError.h
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/6.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTHTTPError : NSError

//用于显示错误信息字段
@property (nonatomic,copy) NSString * message;

@end
