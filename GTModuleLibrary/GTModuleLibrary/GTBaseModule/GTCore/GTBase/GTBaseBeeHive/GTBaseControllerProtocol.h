//
//  GTBaseControllerProtocol.h
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BeeHive/BeeHive.h>
#import "GTPageParam.h"

@protocol GTBaseControllerProtocol <NSObject, BHServiceProtocol>

@property (nonatomic, strong) GTPageParam *pageParam;

@end
