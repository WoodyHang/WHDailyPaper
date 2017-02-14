//
//  CustomerShareView.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/9.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class CustomerShareView: UIView {
    @IBOutlet weak var weiboBtn: UIButton!
    @IBOutlet weak var weChatFriend: UIButton!
    @IBOutlet weak var weChatBtn: UIButton!
    var shareImageString:String?
    ///分享的图片
    var shareImage :UIImage?
    ///分享微博的文字
    var shareText:String?
    ///分享微信的文字
    var shareTextToWeChat:String?
    /// 分享的链接
    var urlString:String?

    @IBAction func weChatBtn(sender: UIButton) {
        let vc = UIView.viewInViewController()
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = self.urlString!
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatTimeline], content: self.shareTextToWeChat, image: self.shareImage, location: nil, urlResource: nil, presentedController: vc, completion: nil)
            }
    @IBAction func cancelShareBtn(sender: UIButton) {
        self.removeFromSuperview()
        
    }
    @IBAction func weBoBtn(sender: UIButton) {
        let vc = UIView.viewInViewController()
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToSina], content: self.shareText, image: self.shareImage, location: nil, urlResource: nil, presentedController: vc, completion: nil)
    }
    @IBAction func weChatFriendBtn(sender: UIButton) {
        let vc = UIView.viewInViewController()
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = self.urlString!
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatSession], content: self.shareTextToWeChat, image: self.shareImage, location: nil, urlResource: nil, presentedController: vc, completion: nil)
    }
    override func awakeFromNib() {
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.8
        if WXApi.isWXAppInstalled() == false {
            weChatBtn.hidden = true
            weChatFriend.hidden = true
        }
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
