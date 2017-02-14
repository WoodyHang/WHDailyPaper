//
//  SuperViewController.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/12.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class SuperViewController: UIViewController {
    ///自定义分享界面
    var customerShareView:CustomerShareView!
    
    var shareImageString:String?
    ///分享的图片
    var shareImage :UIImage?
    ///分享微博的文字
    var shareText:String?
    ///分享微信的文字
    var shareTextToWeChat:String?
    /// 分享的链接
    var urlString:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    ///增加导航栏
    func addNavigatinBar(isShareButton:Bool){
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        let backButton = UIButton()
        backButton.frame = CGRectMake(0, 0, 30, 30)
        backButton.addTarget(self, action: "backBtnClicked:", forControlEvents: UIControlEvents.TouchDown)
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
        if isShareButton == true {
        let shareBtn = UIButton()
        shareBtn.frame = CGRectMake(0, 0, 40, 40)
        shareBtn.addTarget(self, action: "shareBtnClicked:", forControlEvents: UIControlEvents.TouchDown)
        shareBtn.setImage(UIImage(named: "feedShare"), forState:.Normal)
        let rightBtn = UIBarButtonItem(customView: shareBtn)
        self.navigationItem.rightBarButtonItem = rightBtn
        }
    }
    func backBtnClicked(sender:UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func shareBtnClicked(sender:UIButton){
        ///创建一个自定义分享界面
        let nib = NSBundle.mainBundle().loadNibNamed("CustomerShareView", owner: self, options: nil)
        customerShareView = nib[0] as! CustomerShareView
        customerShareView.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENHEIGHT)
        self.view.addSubview(customerShareView)
        customerShareView.shareText = self.shareText
        customerShareView.shareImage = self.shareImage
        customerShareView.shareImageString = self.shareImageString
        customerShareView.urlString = self.urlString
        customerShareView.shareTextToWeChat = self.shareTextToWeChat
        
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
