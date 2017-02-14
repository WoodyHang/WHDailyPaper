//
//  homeModel.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
import YYModel

class homeModel: NSObject,YYModel {
    var icon:String?
    var name:String?
    var id: Int = 0
    var image: String?
    var type: Int = 0
    var post:[String:AnyObject] = [:]
    var has_more:Bool?
    var share:[String:String] = [:]
    var author:[String:AnyObject] = [:]
    var image_large:String?
    var show_type:Int = 0
    
    var subscriber_num: Int = 0

    var post_count: Int = 0
    var content_provider:String?
    ///记录model在数组中的位置
    var index:Int = 0
    var title:String?
    var text:String?
    var url:String?
    }