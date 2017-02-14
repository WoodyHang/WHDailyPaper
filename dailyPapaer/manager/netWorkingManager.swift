//
//  netWorkingManager.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
import AFNetworking
class netWorkingManager: NSObject {
    class func requestData(url:String,par:[String:AnyObject]?,comliapt:(dataSource:AnyObject)->Void){
        let manager = AFHTTPSessionManager();
    
        manager.GET(url, parameters: par, progress: nil, success: { (data:NSURLSessionDataTask, res:AnyObject?) -> Void in
            //print("data\(res!.response)");
            comliapt(dataSource: res!);
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                //print(error.localizedDescription)
                SVProgressHUD.dismiss()
        }
    }
}


