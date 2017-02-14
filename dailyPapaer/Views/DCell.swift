//
//  DCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/24.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class DCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
   
    @IBOutlet weak var praiseLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.layer.borderWidth = 1
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateColor:", name:"updateBackGroundColor", object: nil)
        // Initialization code
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            self.titleLabel.textColor = UIColor.whiteColor()
            self.backView.backgroundColor = UIColor.darkGrayColor()
        }else {
            self.backgroundColor = UIColor.whiteColor()
            self.titleLabel.textColor = UIColor.blackColor()
            self.backView.backgroundColor = UIColor.whiteColor()
        }

    }
    ///通知响应方法
    func updateColor(notif:NSNotification){
        if NSUserDefaults.standardUserDefaults().objectForKey("mode") as! String == "夜间" {
            self.backgroundColor = UIColor.darkGrayColor()
            backView.backgroundColor = UIColor.darkGrayColor()
        }else {
            self.backgroundColor = UIColor.whiteColor()
            backView.backgroundColor = UIColor.whiteColor()
        }
        
    }

    func toCellFillData(model:homeModel) {
        bigImageView.sd_setImageWithURL(NSURL(string: model.image!))
        
        detailTitleLabel.text = model.post["description"] as? String
        titleLabel.text = model.post["title"] as? String
       let num1 = model.post["comment_count"]as? NSNumber
        commentLabel.text = num1?.stringValue
        let num2 = model.post["praise_count"]as?NSNumber
        praiseLabel.text = num2?.stringValue
        let timeStr:String = timeManager.showTime(model)
        self.timeLabel.text = timeStr

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
