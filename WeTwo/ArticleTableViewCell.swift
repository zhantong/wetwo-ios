//
//  ArticleTableViewCell.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/15.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadData(_ article: JSON) {
        contentLabel.text = article["article"].string
    }
}
