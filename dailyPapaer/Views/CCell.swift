//
//  CCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/23.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class CCell: UITableViewCell {
    ///添加栏目
    @IBOutlet weak var addBtn: UIButton!
    var shareImageString:String?
    ///分享的图片
    var shareImage :UIImage?
    ///分享微博的文字
    var shareText:String?
    ///分享微信的文字
    var shareTextToWeChat:String?
    /// 分享的链接
    var urlString:String?
    @IBOutlet weak var backView: UIView!
    ///自定义分享界面
    var customerShareView:CustomerShareView!

    lazy var dataArray:[AnyObject]? = {
        return []
    }()
    var a:Int! = 0
    var dataDict:[Int:AnyObject] = [:]
    //    请求的url字符串数组
    var urlArray:[String] = []
    var tableView:UITableView!
    @IBAction func shareButton(sender: UIButton) {
        let vc = UIView.viewInViewController()
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
//    @IBAction func addButton(sender: UIButton) {
//        print("1111")
//    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //let backViewhight = CGRectGetHeight(backView.frame)
        //let cellhight = CGRectGetHeight(self.frame)
        //print("sefbjhbsjb==\(cellhight)")
        //tableView = UITableView(frame: CGRectMake(0,backViewhight,SCREENWIDTH,340 - backViewhight))
        tableView = UITableView(frame: CGRectMake(42.5, 7.5, 290.0, 368.0))
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNib(UINib(nibName:"DCell", bundle: nil), forCellReuseIdentifier:"DCell")
        self.tableView.separatorStyle = .None
        self.addSubview(tableView)
        tableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        ///添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColor:", name:"updateBackGroundColor", object: nil)
        // Initialization code
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            self.backView.backgroundColor = UIColor.darkGrayColor()
            tableView.backgroundColor = UIColor.darkGrayColor()
                    }else {
            backView.backgroundColor = UIColor.whiteColor()
            self.backgroundColor = UIColor.whiteColor()
            tableView.backgroundColor = UIColor.whiteColor()
            
        }
        

    }
//    func onTap(sender:UITapGestureRecognizer) {
//        let currentVC = UIApplication.sharedApplication().keyWindow?.rootViewController
//        let detailVC = DetailViewController()
//        detailVC.modalTransitionStyle = .PartialCurl
//        detailVC.htmlString = 
//    }
    ///通知响应方法
    func updateColor(notif:NSNotification){
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            backView.backgroundColor = UIColor.darkGrayColor()
            tableView.backgroundColor = UIColor.darkGrayColor()
                    }else {
            self.backgroundColor = UIColor.whiteColor()
            backView.backgroundColor = UIColor.whiteColor()
            tableView.backgroundColor = UIColor.whiteColor()
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    }

