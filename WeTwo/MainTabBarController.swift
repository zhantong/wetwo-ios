//
//  MainTabBarController.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/16.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }


    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController.tabBarItem.tag)
        if viewController.tabBarItem.tag == 1 {
            performSegue(withIdentifier: "newArticle", sender: self)
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newArticle" {
            let newArticleViewController = segue.destination as! newArticleViewController
            newArticleViewController.mainTabBarController = self
            newArticleViewController.parentView = view
        }
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
