//
//  TestModel.swift
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/7.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit
import ObjectMapper

class TestModel: Mappable {

    var userId : Int = 0                //用户ID 唯一标识
    var name: String = ""               //用户昵称
    var phone: String = ""              //手机号码
    var face: String = ""               //头像
    var sex: Int = 0                    //性别：0未知 1男 2女
    var birthday: Int = 0               //出生年月日，UNIX时间戳
    var balance: Int = 0                //用户余额，单位：分
    var point: Int = 0                  //消费积分
    var coupon: Int = 0                 //优惠券数量
    var invoiceMoney: Int = 0           //发票可开金额

    var status: Int = 0                 //0 待反馈；1 已反馈
    var feedbackId: Int = 0             //意见反馈id
    var description : String = ""       //意见内容
    var addTime: Int = 0                //提交时间 时间戳
    var picPaths : [String] = [String]()//照片流
    var replyTime: Int = 0              //回复时间
    var replyContent: String = ""       //回复内容

    init() {}

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        userId <- map["user_id"]
        name <- map["nickname"]
        phone <- map["phone"]
        face <- map["face"]
        sex <- map["sex"]
        birthday <- map["birthday"]
        balance <- map["balance"]
        point <- map["point"]
        coupon <- map["coupon"]
        invoiceMoney <- map["invoice_menoy"]

        status <- map["status"]
        feedbackId <- map["id"]
        description <- map["description"]
        addTime <- map["addtime"]
        picPaths <- map["picture_path"]
        replyTime <- map["reply_time"]
        replyContent <- map["reply_content"]
    }

}
