//
//  SearchCell.swift
//  dailyPapaer
//
//  Created by Woodyhang on 16/5/4.
//  Copyright © 2016年 Woodyhang. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var detailTitleLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var publishTimeLB: UILabel!
    @IBOutlet weak var authorLB: UILabel!
    @IBOutlet weak var categoriesLB: UILabel!
    @IBOutlet weak var cateGoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillUIToCell(model:homeModel){
        self.detailTitleLB.text = model.post["description"] as? String
        self.titleLB.text = model.post["title"] as? String
        self.authorLB.text = model.author["name"] as? String
        self.categoriesLB.text = model.post["category"]!["title"] as? String
        self.cateGoryImage.sd_setImageWithURL(NSURL(string: model.post["category"]!["normal"] as! String))
        let publishTimeStr = timeManager.showTime(model)
        self.publishTimeLB.text = publishTimeStr
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
