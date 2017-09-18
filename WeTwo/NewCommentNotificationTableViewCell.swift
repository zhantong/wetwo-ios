//
//  NewCommentNotificationTableViewCell.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/18.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewCommentNotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadData(_ comment: JSON) {
        userNameLabel.text = comment["user_name"].string! + " 发表了评论"
        timeLabel.text = comment["post_time"].string!
        contentLabel.text = comment["comment"].string!
    }
}
