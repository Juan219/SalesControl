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

    }

    override func viewWillAppear(animated: Bool) {

        var CURRENT_USER: Firebase {
            let userID = ""
            let currentUser = DataService.ds.REF_BASE.childByAppendingPath("users").childByAppendingPath(userID)
            return currentUser
        }

        //        DataService.ds.REF_BASE.observeAuthEventWithBlock { (authData) in
        //
        //        }

        //check if is loggedIn With Facebook.
        guard let fbData = Locksmith.loadDataForUserAccount(facebookAccount) else {
            guard let twData = Locksmith.loadDataForUserAccount(twitterAccount) else {
                guard let gpData = Locksmith.loadDataForUserAccount(googlePlusAccount) else {
                    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                    appDelegate?.showLoginScreen()
                    return
                }
                return
            }
            return
        }
    }
}
