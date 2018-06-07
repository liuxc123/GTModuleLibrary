//
//  UserInfoApi.swift
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/6.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit
import ObjectMapper

class UserInfoApi: GTBaseRequest {

    override func requestUrl() -> String {
        return "/index/user/basic_info"
    }

    override func reformParams() -> [AnyHashable : Any]! {
        return ["user_id": 5]
    }



    open func parsmData() -> TestModel {
        //转化model
        if let testModel = Mapper<TestModel>().map(JSONString: self.parsmDataValueWithJsonString()) {
            return testModel
        } else {
            return TestModel()
        }
    }





}
