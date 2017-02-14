//
//  BCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/22.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class BCell: UITableViewCell {
    var shareImageString:String?
    ///分享的图片
    var shareImage :UIImage?
    ///分享微博的文字
    var shareText:String?
    ///分享微信的文字
    var shareTextToWeChat:String?
    /// 分享的链接
    var urlString:String?
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    ///自定义分享界面
    var customerShareView:CustomerShareView!
    ///分享按钮
    @IBAction func shareBtn(sender: UIButton) {
        let vc = UIView.viewInViewController()
//        UMSocialSnsService.presentSnsIconSheetView(vc, appKey: "572ae3cce0f55a20590016c5", shareText: shareText, shareImage: shareImage, shareToSnsNames:nil, delegate: nil)
//        UMSocialSnsService.presentSnsIconSheetView(vc, appKey: "572ae3cce0f55a20590016c5", shareText: shareText, shareImage: shareImage, shareToSnsNames:[UMShareToSina], delegate: nil)

//        let urlResource = UMSocialUrlResource(snsResourceType:UMSocialUrlResourceTypeImage, url: self.shareImageString)
//        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToSina], content: self.shareText, image: nil, location: nil, urlResource: urlResource, presentedController: vc, completion: nil)
//        UMSocialData.defaultData().extConfig.sinaData.shareText = self.shareText
//        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = self.shareTextToWeChat
//        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = self.shareTextToWeChat
//        UMSocialData.defaultData().extConfig.wechatFavoriteData.shareText = self.shareTextToWeChat
//       //微信
//        UMSocialSnsService.presentSnsIconSheetView(vc, appKey: "572ae3cce0f55a20590016c5", shareText:nil, shareImage: self.shareImage, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite], delegate: nil)
//
//        UMSocialData.defaultData().extConfig.wechatTimelineData.url = self.urlString
//        UMSocialData.defaultData().extConfig.wechatFavoriteData.url = self.urlString
//        UMSocialData.defaultData().extConfig.wechatSessionData.url = self.urlString
        ///创建一个自定义分享界面
        let nib = NSBundle.mainBundle().loadNibNamed("CustomerShareView", owner: self, options: nil)
        customerShareView = nib[0] as! CustomerShareView
        customerShareView.frame = CGRectMake(0, 0, SCREENHEIGHT, SCREENHEIGHT)
        vc.view.addSubview(customerShareView)
        customerShareView.shareText = self.shareText
        customerShareView.shareImage = self.shareImage
        customerShareView.shareImageString = self.shareImageString
        customerShareView.urlString = self.urlString
        customerShareView.shareTextToWeChat = self.shareTextToWeChat
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ///为backview添加一个点击手势
        let tap = UITapGestureRecognizer(target: self, action: "onTap:")
        backView.addGestureRecognizer(tap)
        ///添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColor:", name:"updateBackGroundColor", object: nil)
        // Initialization code
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            self.titleLabel.textColor = UIColor.whiteColor()
            backView.backgroundColor = UIColor.darkGrayColor()
        }else {
            self.backgroundColor = UIColor.whiteColor()
            self.titleLabel.textColor = UIColor.blackColor()
            backView.backgroundColor = UIColor.whiteColor()
        }

    }
    ///通知响应方法
    func updateColor(notif:NSNotification){
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            self.titleLabel.textColor = UIColor.whiteColor()
            backView.backgroundColor = UIColor.darkGrayColor()
        }else {
            self.backgroundColor = UIColor.whiteColor()
            self.titleLabel.textColor = UIColor.blackColor()
            backView.backgroundColor = UIColor.whiteColor()
        }
        
    }

    func toCellFillData(model:homeModel) {
        let str1 = model.post["column"]!["share"]!!["title"] as! String
        let str2 = model.post["column"]!["share"]!!["text"] as! String
        self.urlString =  model.post["column"]!["share"]!!["url"] as? String
        self.shareText = str1 + "\n" + str2 + "\n" + self.urlString!
        self.shareTextToWeChat = str1 + "\n" + str2 + "\n"
        let str3 = model.post["column"]!["share"]!!["image"] as! String
        self.shareImageString = str3
        let imageData = NSData(contentsOfURL: NSURL(string: str3)!)
        self.shareImage = UIImage(data: imageData!)
//        print(self.shareImage)
        nameLabel!.text = model.post["column"]!["name"] as? String
        detailLabel!.text = model.post["description"] as? String
        titleLabel.text = model.post["title"] as? String
        iconImageView.sd_setImageWithURL(NSURL(string: (model.post["column"]!["icon"] as? String)!))
        bigImageView.sd_setImageWithURL(NSURL(string: (model.post["image"])! as! String))
        smallImageView.sd_setImageWithURL(NSURL(string: (model.post["category"]!["image_lab"] as?String)!))
    }
    ///手势点击事件
    func onTap(sender:UITapGestureRecognizer){
        let vc = OwnShareController()
        let vc1 = UIView.viewInViewController()
        vc.titleString = self.nameLabel.text
        vc.urlString = self.urlString
        vc.shareImage = self.shareImage
        vc.shareText = self.shareText
        vc.shareTextToWeChat = self.shareTextToWeChat
        vc.shareImageString = self.shareImageString
        vc1.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
