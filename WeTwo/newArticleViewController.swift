//
//  newArticleViewController.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/16.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class newArticleViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!

    var placeholderLabel: UILabel!


    var mainTabBarController: MainTabBarController!

    var parentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postButton.action = #selector(postButtonClicked)
        cancelButton.action = #selector(cancelButtonClicked)

        contentTextView.delegate = self

        placeholderLabel = UILabel()
        placeholderLabel.text = "内容..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (contentTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        contentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (contentTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !contentTextView.text.isEmpty
    }

    func postButtonClicked() {
        let article = contentTextView.text!

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.frame.size.width * 0.5, y: view.frame.size.height * 0.5)
        activityIndicator.startAnimating()

        let articleParams: Parameters = [
            "article": article
        ]
        Alamofire.request(baseUrl + "api/postArticle", method: .post, parameters: articleParams).responseJSON {
            response in

            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()

            self.parentView.makeToast("发布成功", duration: 2.0, position: .center)

            self.dismiss(animated: true, completion: nil)
        }
    }

    func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
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
