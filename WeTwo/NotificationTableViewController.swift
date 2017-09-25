//
//  NotificationTableViewController.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/18.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NotificationTableViewController: UITableViewController {
    var notifications = [JSON]()
    var selectedArticleId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0

        tableView.register(UINib(nibName: "NewCommentNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NewCommentNotificationTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        Alamofire.request(baseUrl + "api/getUnreadComments").responseJSON {
            response in
            self.notifications = JSON(response.result.value!).array!
            self.tabBarController?.tabBar.items?[2].badgeValue = self.notifications.count == 0 ? nil : String(self.notifications.count)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCommentNotificationTableViewCell", for: indexPath) as! NewCommentNotificationTableViewCell

        // Configure the cell...
        cell.loadData(notifications[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let params: Parameters = [
            "commentId": notifications[indexPath.row]["comment_id"].int!
        ]
        Alamofire.request(baseUrl + "api/setCommentRead", method: .post, parameters: params).responseJSON {
            response in
        }

        selectedArticleId = notifications[indexPath.row]["article_id"].int!
        performSegue(withIdentifier: "article", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "article" {
            let articleViewController = segue.destination as! ArticleViewController
            articleViewController.articleId = selectedArticleId
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
