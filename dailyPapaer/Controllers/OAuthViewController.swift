//
//  OAuthViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/25.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
import AFNetworking
class OAuthViewController: SuperViewController,UIWebViewDelegate {
    var userName:String?
    var userIconUrl:String?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigatinBar(false)
        webView.delegate = self
        loadWebView()
        
        // Do any additional setup after loading the view.
    }
    ///加载webview
    func loadWebView(){
        let url = NSURL(string: wb_OAuth_API + "?client_id=" + wb_appKey + "&redirect_uri=" + wb_redirecturl + "&forcelogin=true")
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    /* UIWebViewDelegate */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        if (urlString?.containsString("code=") == true) && (urlString?.containsString(wb_redirecturl) == true) {
            let array:[String] = (urlString?.componentsSeparatedByString("code="))!
            let code = array.last
            ///获取第2把钥匙
            self.getAccesstokenWithCode(code!)
            return false
        }
        return true
    }
    //获取accesstoken
    func getAccesstokenWithCode(code:String){
        ///生成参数
        var params:[String:String] = [:]
        params["client_id"] = wb_appKey
        params["client_secret"] = wb_appSecret
        params["code"] = code
        params["grant_type"] = "authorization_code"
        params["redirect_uri"] = wb_redirecturl
        let manager = AFHTTPSessionManager();
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/plain") as? Set<String>
        manager.POST(wb_api_getAccessToken, parameters: params, progress: nil, success: { (task:NSURLSessionDataTask, id:AnyObject?) -> Void in
            var dict:[String:AnyObject] = [:]
            dict["access_token"] = id!["access_token"] as? String
            //self.accesstoken = id!["access_token"] as? String
            let dateNumber = id!["expires_in"] as! NSNumber
            let i:NSTimeInterval = dateNumber as NSTimeInterval
            let date = NSDate(timeIntervalSince1970: i)
            dict["expirationDate"] = date
            dict["uid"] = id!["uid"] as? String
            var dic:[String:AnyObject] = [:]
            dic["access_token"] = id!["access_token"] as? String
            dic["uid"] = id!["uid"] as? String
            
            manager.GET(wb_user_message, parameters: dic, progress: nil, success: { (task:NSURLSessionDataTask, id:AnyObject?) -> Void in
                ///获取用户名，头像
                self.userName = id!["name"] as? String
                self.userIconUrl = id!["avatar_hd"]as? String
                
                }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                    print(error.localizedDescription)
            }
            
            ///通过授权信息注册登录
            BmobUser.loginInBackgroundWithAuthorDictionary(dict, platform:BmobSNSPlatformSinaWeibo, block: { (user:BmobUser!, error:NSError!) -> Void in
                if error == nil {
                    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "isLogin")
                    ///微博登录
                    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "isWeiboLogin")
                    NSNotificationCenter.defaultCenter().postNotificationName("refreshUserMsg", object: nil)
                    ///更新栏目中心页面的section ＝＝ 0 的UI
                    NSNotificationCenter.defaultCenter().postNotificationName("refreshMyFocus", object: nil)
//                    NSUserDefaults.standardUserDefaults().setObject(self.userName, forKey: "userName")
//                    NSUserDefaults.standardUserDefaults().setObject(self.userIconUrl, forKey: "userIconUrl")
                    user.username = self.userName
                    user.setObject(self.userIconUrl, forKey: "userIconUrl")
                    user.updateInBackgroundWithResultBlock({ (isSuccessful:Bool, error:NSError!) -> Void in
                        if isSuccessful == true {
                            //print(user)
                        }
                    })
                    self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
                } else {
                    SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                }
                
            })
                        }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                SVProgressHUD.showErrorWithStatus(error.localizedDescription)
        }
    }
    //    func requestWeiBoUserMsg(){
    //        let manager = AFHTTPSessionManager()
    //        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/plain") as? Set<String>
    //        var dic:[String:AnyObject] = [:]
    //        dic["access_token"] = self.accesstoken
    //        dic["uid"] = self.uid
    //        manager.GET(wb_user_message, parameters: dic, progress: nil, success: { (task:NSURLSessionDataTask, id:AnyObject?) -> Void in
    //            ///获取用户名，头像
    //
    //            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
    //                print(error.localizedDescription)
    //        }
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
