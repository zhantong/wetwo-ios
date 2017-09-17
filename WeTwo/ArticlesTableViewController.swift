//
//  ArticlesTableViewController.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/15.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PullToRefreshKit

class ArticlesTableViewController: UITableViewController {
    var articles = [JSON]()
    var selectedArticleId = 0
    var offset = 0
    var limit = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0

        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        tableView.setUpHeaderRefresh {
            let params: Parameters = [
                "offset": 0,
                "limit": self.limit
            ]
            Alamofire.request("http://192.168.1.2:5000/api/getAllArticles", parameters: params).responseJSON {
                response in
                self.articles = JSON(response.result.value!).array!
                self.offset = self.limit
                self.tableView.reloadData()
                self.tableView.endHeaderRefreshing(.success)
            }
        }
        tableView.setUpFooterRefresh {
            let params: Parameters = [
                "offset": self.offset,
                "limit": self.limit
            ]
            Alamofire.request("http://192.168.1.2:5000/api/getAllArticles", parameters: params).responseJSON {
                response in
                let json = JSON(response.result.value!)
                self.articles.append(contentsOf: json.array!)
                self.offset += self.limit
                self.tableView.reloadData()
                self.tableView.endFooterRefreshing()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        loadCookies()

        Alamofire.request("http://192.168.1.2:5000/api/getUserInfo").responseJSON {
            response in
            let statusCode = response.response?.statusCode
            if statusCode == 401 {
                self.performSegue(withIdentifier: "login", sender: self)
            } else {
                self.tableView.beginHeaderRefreshing()
            }
        }
    }

    func loadCookies() {
        guard let cookieArray = UserDefaults.standard.array(forKey: "savedCookies") as? [[HTTPCookiePropertyKey: Any]] else {
            return
        }
        for cookieProperties in cookieArray {
            if let cookie = HTTPCookie(properties: cookieProperties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
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
        return articles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell

        // Configure the cell...
        cell.loadData(articles[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticleId = articles[indexPath.row]["article_id"].int!
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
