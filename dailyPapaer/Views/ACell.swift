//
//  ACell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/22.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit
class ACell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var praiseCountLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var detaiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image1View: UIImageView!

    override func awakeFromNib() {
                super.awakeFromNib()
        ///添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColor:", name:"updateBackGroundColor", object: nil)
        // Initialization code
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            self.titleLabel.textColor = UIColor.whiteColor()
        }else {
            self.backgroundColor = UIColor.whiteColor()
            self.titleLabel.textColor = UIColor.blackColor()
            
        }

        // Initialization code
    }
    ///通知响应方法
    func updateColor(notif:NSNotification){
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            self.titleLabel.textColor = UIColor.whiteColor()
        }else {
            self.backgroundColor = UIColor.whiteColor()
            self.titleLabel.textColor = UIColor.blackColor()
        }
        
    }

     func toCellFillData(model:homeModel)  {
//        publish_time
        self.image1View.sd_setImageWithURL(NSURL(string: model.image!))
        self.titleLabel.text = model.post["title"] as? String
        self.detaiLabel.text = model.post["description"] as? String
        let str1:String = model.post["category"]!["title"] as! String
        let num = model.post["comment_count"] as! NSNumber
        let str2:String = num.stringValue
        label1.text = str1 + " \(str2)"
        let num2 = model.post["praise_count"] as! NSNumber
        let str3 = num2.stringValue
        praiseCountLabel.text = str3
        let timeStr:String = timeManager.showTime(model)
        self.timeLabel.text = timeStr
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
