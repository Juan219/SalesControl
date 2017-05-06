//
//  MainTabBarController.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/21/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit
import Locksmith

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        if User.currentUser().isLoggedIn() == false {
            let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            appDelegate?.showLoginScreen()
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.tintColor  = appColorNegro

        var CURRENT_USER: Firebase {
            let userID = ""
            let currentUser = DataService.ds.REF_BASE.childByAppendingPath("users").childByAppendingPath(userID)
            return currentUser
        }
     }

    @IBAction func deleteAccountButtonPressed(sender: AnyObject) {
        User.currentUser().deleteAccounts()
    }
}
