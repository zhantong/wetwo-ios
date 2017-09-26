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
import KMPlaceholderTextView

class Comment {
    var comment: String = ""
    var commentId: Int = 0
    var parentCommentId: Int = 0
    var time: String = ""
    var userName: String = ""
    var parentUserName: String?

    init(comment: String, commentId: Int, parentCommentId: Int, time: String, userName: String, parentUserName: String?) {
        self.comment = comment
        self.commentId = commentId
        self.parentCommentId = parentCommentId
        self.time = time
        self.userName = userName
        self.parentUserName = parentUserName
    }

    func toText() -> String {
        var result = userName
        if parentUserName != nil {
            result += " 回复 " + parentUserName!
        }
        result += ": " + comment
        return result
    }
}

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var articleId = 0
    var comments = [Comment]()
    var parentCommentId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTableView.delegate = self
        commentTableView.dataSource = self

        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")

        commentTableView.tableFooterView = UIView(frame: .zero)
        commentTableView.rowHeight = UITableViewAutomaticDimension
        commentTableView.estimatedRowHeight = 44.0

        commentTextView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.cornerRadius = 5.0
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
        reloadArticle()
    }

    func reloadArticle() {
        let articleParams: Parameters = [
            "articleId": self.articleId
        ]

        Alamofire.request(baseUrl + "api/getArticle", method: .get, parameters: articleParams).responseJSON {
            response in
            let article = JSON(response.result.value!)
            self.contentLabel.text = article["article"].string
            self.userNameLabel.text = article["user_name"].string
            self.timeLabel.text = article["post_time"].string
            self.comments.removeAll()
            self.extractComments(article["comments"])
            self.commentTableView.reloadData()
        }
    }

    func postComment(articleId: Int, comment: String, parentCommentId: Int, callBack: @escaping () -> Void) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.frame.size.width * 0.5, y: view.frame.size.height * 0.5)
        activityIndicator.startAnimating()

        let commentParams: Parameters = [
            "articleId": articleId,
            "comment": comment,
            "parentCommentId": parentCommentId
        ]
        Alamofire.request(baseUrl + "api/postComment", method: .post, parameters: commentParams).responseJSON {
            response in

            callBack();
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

    func keyboardWillChange(_ note: NSNotification) {
        let frame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint.constant = view.frame.size.height - frame.origin.y + 8
        let duration = (note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func keyboardWillHide(_ note: NSNotification) {
        parentCommentId = 0
        commentTextView.text = ""
        commentTextView.placeholder = "评论"
    }

    func extractComments(_ commentsJson: JSON) {
        for (index, commentJson): (String, JSON) in commentsJson {
            comments.append(Comment(comment: commentJson["comment"].string!, commentId: commentJson["comment_id"].int!, parentCommentId: commentJson["parent_comment_id"].int!, time: commentJson["post_time"].string!, userName: commentJson["user_name"].string!, parentUserName: commentJson["parent_user_name"].string))
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
        cell.contentLabel.text = comments[indexPath.row].toText()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentCommentId = comments[indexPath.row].commentId
        commentTextView.placeholder = "回复 " + comments[indexPath.row].userName + ":"
        commentTextView.becomeFirstResponder()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let comment = textView.text!
            postComment(articleId: articleId, comment: comment, parentCommentId: parentCommentId, callBack: {
                self.reloadArticle()
            })
            textView.resignFirstResponder()
        }
        return true
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
