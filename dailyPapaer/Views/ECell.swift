//
//  ECell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/10.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class ECell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var smallImageView: UIImageView!
    @IBOutlet weak var bigImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func toCellFillData(model:homeModel) {
        detailLabel!.text = model.post["description"] as? String
        titleLable.text = model.post["title"] as? String

        bigImageView.sd_setImageWithURL(NSURL(string: (model.post["image"])! as! String))
        smallImageView.sd_setImageWithURL(NSURL(string: (model.post["category"]!["image_lab"] as?String)!))
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
