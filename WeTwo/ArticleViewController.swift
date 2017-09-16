//
//  ArticleViewController.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/15.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Comment {
    var comment: String = ""
    var commentId: Int = 0
    var parentCommentId: Int = 0
    var time: String = ""
    var userName: String = ""

    init(comment: String, commentId: Int, parentCommentId: Int, time: String, userName: String) {
        self.comment = comment
        self.commentId = commentId
        self.parentCommentId = parentCommentId
        self.time = time
        self.userName = userName
    }
}

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!

    var articleId = 0
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTableView.delegate = self
        commentTableView.dataSource = self

        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")

        commentTableView.tableFooterView = UIView(frame: .zero)
        commentTableView.rowHeight = UITableViewAutomaticDimension
        commentTableView.estimatedRowHeight = 44.0

        let loginParams: Parameters = [
            "name": "北极熊",
            "password": "123456"
        ]

        // Do any additional setup after loading the view.
        Alamofire.request("http://192.168.1.2:5000/api/login", method: .post, parameters: loginParams).responseJSON {
            response in

            Alamofire.request("http://192.168.1.2:5000/api/getArticle", method: .get, parameters: ["articleId": self.articleId]).responseJSON {
                response in
                let article = JSON(response.result.value!)
                self.contentLabel.text = article["article"].string
                self.extractComments(article["comments"])
                self.commentTableView.reloadData()
            }
        }

    }

    func extractComments(_ commentsJson: JSON) {
        for (index, commentJson): (String, JSON) in commentsJson {
            comments.append(Comment(comment: commentJson["comment"].string!, commentId: commentJson["comment_id"].int!, parentCommentId: commentJson["parent_comment_id"].int!, time: commentJson["post_time"].string!, userName: commentJson["user_name"].string!))
            extractComments(commentJson["children"])
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell

        // Configure the cell...
        cell.contentLabel.text = comments[indexPath.row].comment

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
