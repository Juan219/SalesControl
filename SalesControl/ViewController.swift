//
//  ViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/20/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate{

    private var uuid: NSUUID?

    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //FBLoginButton.delegate = self
        //FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        let facebookData : [String : AnyObject] = ["facebookToken" : result.token]

        let facebookAccountData : String = "facebookAccountData"
        do { try Locksmith.saveData(facebookData, forUserAccount: facebookAccountData) }
        catch {
            print("Error to save the facebook credentials")
        }

        print(result)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

        print("Logging out")
    }

    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    func getDataIdentifier() {
         

    }


}

