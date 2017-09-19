//
//  LoginViewController.swift
//  WeTwo
//
//  Created by zhantong on 2017/9/17.
//  Copyright © 2017年 Tong Zhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }

    func loginButtonClicked() {
        let userName = usernameTextField.text!
        let password = passwordTextField.text!

        let loginParams: Parameters = [
            "name": userName,
            "password": password
        ]

        let controller = self

        Alamofire.request(baseUrl + "api/login", method: .post, parameters: loginParams).responseJSON {
            response in
            let json = JSON(response.result.value!)
            if json["status"].bool! {
                self.saveCookies(response: response)
                controller.dismiss(animated: true, completion: nil)
            } else {
                self.view.makeToast("登录失败", duration: 2.0, position: .center)
            }
        }
    }

    func saveCookies(response: DataResponse<Any>) {
        let headerFields = response.response?.allHeaderFields as! [String: String]
        let url = response.response?.url
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
        var cookieArray = [[HTTPCookiePropertyKey: Any]]()
        for cookie in cookies {
            cookieArray.append(cookie.properties!)
        }
        UserDefaults.standard.set(cookieArray, forKey: "savedCookies")
        UserDefaults.standard.synchronize()
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
