//
//  DataBaseManager.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/6/28.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class DataBaseManager: NSObject {
    ///数据库
    var db:FMDatabase?
    ///单例
    static let shareInstance:DataBaseManager = DataBaseManager()
    override init() {
        super.init()
        initDB()
    }
    ///初始化数据库
    func initDB(){
        if (db == nil) {
            //将数据库存放进沙和路径下的Documents中
            let dbPath = NSHomeDirectory().stringByAppendingString("/Documents/dailyPapaer.db")
            print(dbPath)
            ///创建数据库
            db = FMDatabase(path: dbPath)
        }
            ///打开数据库
            if db!.open(){
                ///创建数据库表
                db!.executeUpdate("create TABLE if not exists collection (Id INTEGER primary key,Name text, Image text,Content_provider text,Post_count INTEGER,Subscriber_num INTEGER);", withArgumentsInArray: nil)
            }else {
                print("打开数据库失败")
            }
    }
    // 判断数据库中是否存在对应数据
    func isExistsWithAppId(id:Int) -> Bool{
        // 从数据库查询对应appid的数据
        let arr = [id]
        
        let rs:FMResultSet = db!.executeQuery("select * from collection where Id=?" , withArgumentsInArray: arr)
        if rs.next(){
            return true
        }else {
            return false
        }
    }
    // 插入数据
    func insertCollectionTableModel(model:homeModel) -> Bool {
        //判断数据是否存在
        if self.isExistsWithAppId(model.id) == true {
            ///更新已存在的数据
            let isSuccess:Bool = (db!.executeUpdate("update collection SET Name=?, Image=? where Id=? where Content_provider=? where Post_count=? where Subscriber_num=?", withArgumentsInArray: [model.name!,model.image!,model.id,model.content_provider!,model.post_count,model.subscriber_num]))
            return isSuccess
        }else {
            let isSuccess:Bool = (db!.executeUpdate("insert into collection values(?, ?, ?, ?, ?, ?)", withArgumentsInArray: [model.id,model.name!,model.image!,model.content_provider!,model.post_count,model.subscriber_num]))
            return isSuccess
        }
    }
///获取表中的所有数据
    func getAllCollection() -> [homeModel]{
        var collectionModels:[homeModel] = []
        let rs = db!.executeQuery("select * from collection", withArgumentsInArray: nil)
        if rs != nil{
        while (rs.next()){
            let model:homeModel = homeModel()
            model.id = Int(rs.intForColumn("Id"))
            model.name = rs.stringForColumn("Name")
            model.image = rs.stringForColumn("Image")
            model.subscriber_num = Int(rs.intForColumn("Subscriber_num"))
            model.post_count = Int(rs.intForColumn("Post_count"))
            model.content_provider = rs.stringForColumn("Content_provider")
            //model.index = Int(rs.intForColumn("Index"))
            collectionModels.append(model)
        }
        }
        return collectionModels
    }
    ///删除数据
    func deleteColletionTableModel(model:homeModel) -> Bool{
        if self.isExistsWithAppId(model.id){
            let isSuccess:Bool = db!.executeUpdate("DELETE FROM collection where Id=?", withArgumentsInArray: [model.id])
            return isSuccess
        }else {
            return false
        }
    }
}
