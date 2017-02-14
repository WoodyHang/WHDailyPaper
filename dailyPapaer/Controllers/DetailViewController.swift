//
//  DetailViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/4/5.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate {
    var subview:UIView!
//    添加自定义的返回按钮
    var backButton:UIButton!
    var htmlString:String!
    var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
             // Do any additional setup after loading the view.
        SVProgressHUD.showWithStatus("数据加载中")
        createUI()

        // Initialization code
        
    }
        override func viewDidAppear(animated: Bool) {
        SVProgressHUD.dismiss()

    }
    func createUI() {
        webView = UIWebView(frame:UIScreen.mainScreen().bounds)
        self.view.addSubview(webView)
        webView.delegate = self
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: self.htmlString)!))
            self.webView.reload()
        }
        backButton = UIButton(frame: CGRectMake(10,SCREENHEIGHT-50,50,50))
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "navigation_back_round_normal"), forState:.Normal)
        backButton.layer.cornerRadius = 25
        backButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
       //self.webView.scrollView.addObserver(self, forKeyPath: "contentOffset", options:.New, context:nil)
    }
   //override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    //if self.webView.scrollView.contentOffset.y != 0 {
//        let buttonH = self.webView.scrollView.contentOffset.y
//        backButton.frame.origin.y = buttonH
//    }
//       }
//    deinit {
//        self.webView.scrollView.removeObserver(self, forKeyPath: "contentOffset")
//    }
    func buttonClicked(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        let string = "document.getElementsByClassName('com-header clearfix')[0].remove();"
        self.webView.stringByEvaluatingJavaScriptFromString(string)
//        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
//        NSString *js = "window.onload = function(){
//        
//        document.body.style.backgroundColor = '#3333';//#3333 is your color
//        
//    }
  
    
//   self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName_r('body')[0].style.background='#9A9C9B'");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
