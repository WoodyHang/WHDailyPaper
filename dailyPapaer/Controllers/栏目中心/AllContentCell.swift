//
//  AllContentCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/6/20.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class AllContentCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var IconImageView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var label3: UILabel!
  
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.borderWidth = 0.5
        // Initialization code
    }
    func fillToData(model:homeModel){
        self.IconImageView.sd_setImageWithURL(NSURL(string: model.image!))
        self.label1.text = model.content_provider!
        self.label2.text = String(model.subscriber_num) + "人已订阅，更新至" + String(model.post_count) + "篇"
        self.label3.text = model.name
    }
}
