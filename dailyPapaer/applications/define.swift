//
//  define.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import Foundation
import UIKit
let SCREENWIDTH = UIScreen.mainScreen().bounds.size.width
let SCREENHEIGHT = UIScreen.mainScreen().bounds.size.height
///首页数据
let KHOMEURL = "http://app3.qdaily.com/app3/homes/index/"
//http://app3.qdaily.com/app3/homes/index/MTQ1ODA5MDE4MF9fXzE0NTgwOTg1ODg%3D.json?
///专题数据
let KTOPICURL = "http://app3.qdaily.com/app3/columns/index/"
//"http://app3.qdaily.com/app3/columns/index/22/0.json?"
///所有专题数据接口
let AllColumns = "http://app3.qdaily.com/app3/columns/all_columns_index/"
//http://app3.qdaily.com/app3/columns/all_columns_index/0.json?
///x新闻分类
let newsCategoriesUrl = "http://app3.qdaily.com/app3/categories/index/"
///搜索借口
let searchUrl = "http://app3.qdaily.com/app3/searches/post_list?last_key="
///好奇心研究所接口
let curiosityUrl = "http://app3.qdaily.com/app3/columns/index/2/"
//0.json?
//""http://app3.qdaily.com/app3/searches/post_list?last_key=0&search=%E5%9F%8E%E5%B8%82
///微博请求授权接口
let wb_OAuth_API = "https://api.weibo.com/oauth2/authorize"
///微博appkey
let wb_appKey = "3823707035"
///微博回调地址
let wb_redirecturl = "http://www.1000phone.com/"
///微博密钥
let wb_appSecret = "92718ad1554a6c8e1a5fb58e3896d74d"
/** 获取Accesstoken*/
let wb_api_getAccessToken = "https://api.weibo.com/oauth2/access_token"
///微博用户信息
let wb_user_message = "https://api.weibo.com/2/users/show.json"
///普通view所在的视图控制器
extension UIView {
   class func viewInViewController() -> UIViewController {
        let viewVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        return viewVC!
    }
}
extension UIViewController{
    //当加载页面过后
    func touchInViewHideKeyboard(){
        //隐藏键盘
        let tap = UITapGestureRecognizer(target: self, action: "hideKeyboard");
        tap.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tap);
    }
    
    
    ///点击view的其他区域隐藏键盘
    func hideKeyboard(){
        self.view.endEditing(true);
}
}