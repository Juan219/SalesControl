//
//  ViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/20/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate,FBSDKGraphRequestConnectionDelegate {

    private var uuid: String?
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var facebookUserNameLabel: UILabel!
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var twitterUserNameLabel: UILabel!
    @IBOutlet weak var googleplusImageView: UIImageView!
    @IBOutlet weak var googleplusUserNameLabel: UILabel!
    

    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startView()
        FBLoginButton.delegate = self
        FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
    }

    func startView() {
        facebookImageView.hidden = true
        facebookUserNameLabel.hidden = true
        twitterImageView.hidden = true
        twitterUserNameLabel.hidden = true
        googleplusImageView.hidden = true
        googleplusUserNameLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        if (FBSDKAccessToken.currentAccessToken() != nil) {

            var accountInfo = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,cover"])

            accountInfo.startWithCompletionHandler({ (connection, result, error) -> Void in

                self.facebookUserNameLabel.hidden = false
                self.facebookUserNameLabel.text = String(result.valueForKey("name")!)

                if let data = NSData(contentsOfURL: NSURL(string: result.valueForKey("cover")?.valueForKey("source") as! String)!) {
                    let image = UIImage(data: data)



                    UIView.animateWithDuration(1, animations: { () in
                        self.FBLoginButton.frame.size.width = 0
                        self.facebookImageView.image = image

                        }, completion: { (value: Bool) in
                            self.FBLoginButton.hidden = true
                            self.facebookImageView.hidden = false
                    })
                }



            })

        }

    }

    func requestConnectionDidFinishLoading(connection: FBSDKGraphRequestConnection!) {
        print("")
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

        print("Logging out")
    }

    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    func getDataIdentifier() {
        let defaults = NSUserDefaults.standardUserDefaults()

        
    }


}

