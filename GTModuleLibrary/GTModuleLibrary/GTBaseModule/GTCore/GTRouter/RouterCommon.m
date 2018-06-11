//
//  RouterCommon.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "RouterCommon.h"

GT_EXTERN NSString* GTRootRoute(NSString *schema, NSString *path) {
    return [NSString stringWithFormat: @"%@:/%@", schema, path];
}

GT_EXTERN NSURL* GTRootRouteURL(NSString *schema, NSString *path) {
    return [NSURL URLWithString:[GTRootRoute(schema, path) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}
