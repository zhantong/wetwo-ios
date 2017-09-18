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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countCommentLabel: UILabel!

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
        userNameLabel.text = article["user_name"].string
        timeLabel.text = article["post_time"].string!
        countCommentLabel.text = "回复 " + String(article["num_comments"].int!)
    }
}
