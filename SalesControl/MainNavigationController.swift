//
//  MainNavigationController.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/21/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController,UINavigationControllerDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Loading the init view")
    }

    override func viewDidLoad() {
        //check if the user is loggedIn
        print("Loading......")
    }
}
