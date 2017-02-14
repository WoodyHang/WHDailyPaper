//
//  FeedsCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/3/21.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class FeedsCell: UITableViewCell {

    @IBOutlet weak var imageView1: UIImageView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var praiseCount: UILabel!
    @IBOutlet weak var label1: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    var _model:homeModel!
    var model:homeModel!{
        set {
      self._model = newValue
     titleLabel.text = _model.post["title"] as?String
            let urlImage = NSURL(string: _model.image!)
            let request = NSURLRequest(URL: urlImage!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (requst, data, error) -> Void in
                let image = UIImage(data: data!)
                self.imageView1.image = image
            }
//                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            let date:NSData = NSData(contentsOfURL: NSURL(string: self._model.image!)!)!
//                let image = UIImage(data: date)
//                self.imageView1.image = image
//
//            
//                        }

        let str1:String = _model.post["category"]!["title"] as! String
        let num = _model.post["comment_count"] as! NSNumber
        let str2:String = num.stringValue
            label1.text = str1 + str2
        let num2 = _model.post["praise_count"] as! NSNumber
        let str3 = num2.stringValue
            self.praiseCount.text = str3
        let timeStr:String = timeManager.showTime(model)
        self.timeLabel.text = timeStr
        }
get {
    return self._model
        }
    }
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
