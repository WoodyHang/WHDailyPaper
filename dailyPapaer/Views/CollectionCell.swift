//
//  CollectionCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/11.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var praiseLabel: UILabel!
    @IBOutlet weak var commentLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!
    var _model:homeModel!
    var model:homeModel!{
        set {
            self._model = newValue
            titleLabel.text = _model.post["title"] as?String
            let urlImage = NSURL(string: _model.image!)
            let request = NSURLRequest(URL: urlImage!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (requst, data, error) -> Void in
                let image = UIImage(data: data!)
                self.bigImageView.image = image
            }
            
            let num = _model.post["comment_count"] as! NSNumber
            let str2:String = num.stringValue
            commentLable.text = str2
            let num2 = _model.post["praise_count"] as! NSNumber
            let str3 = num2.stringValue
            praiseLabel.text = str3
        }
        get {
            return self._model
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
