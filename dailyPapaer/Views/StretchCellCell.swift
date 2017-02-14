//
//  StretchCellCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/10.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class StretchCellCell: UITableViewCell {
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
