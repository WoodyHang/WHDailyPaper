//
//  MyFocusTableViewCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/6/17.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class MyFocusTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var lable2: UILabel!
    @IBOutlet weak var label3: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.layer.borderWidth = 0.5
        // Initialization code
    }
    func fillToData(model:homeModel){
        self.iconImageView.sd_setImageWithURL(NSURL(string: model.image!))
        self.label1.text = model.content_provider!
        self.lable2.text = String(model.subscriber_num) + "人已订阅，更新至" + String(model.post_count) + "篇"
        self.label3.text = model.name
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
