//
//  UserInfoApi.swift
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/6.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit

class UserInfoApi: GTBaseRequest {

    override func requestUrl() -> String {
        return "/index/user/basic_info"
    }

    override func reformParams() -> [AnyHashable : Any]! {
        return ["user_id": 1]
    }





}
