//
//  ViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/20/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit
import Twitter

class ViewController: UIViewController,FBSDKGraphRequestConnectionDelegate, UIAlertViewDelegate {
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    @IBOutlet weak var googleplusLoginButton: GIDSignInButton!

    var timer : NSTimer?
    private var uuid: String?

    @IBOutlet weak var doneButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.darkGrayColor().CGColor


        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(animateButtons), userInfo: nil, repeats: true)

    }

    override func viewWillAppear(animated: Bool) {
        //animateButtons()
        //timer?.fire()
    }


    func animateButtons() {

        facebookLoginButton.transform = CGAffineTransformMakeScale(0.85, 0.85)
        twitterLoginButton.transform = CGAffineTransformMakeScale(0.85, 0.85)
        googleplusLoginButton.transform = CGAffineTransformMakeScale(0.85, 0.85)

        UIView.animateWithDuration(1.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 1.4,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.facebookLoginButton.transform = CGAffineTransformIdentity
                                    self.twitterLoginButton.transform = CGAffineTransformIdentity
                                    self.googleplusLoginButton.transform = CGAffineTransformIdentity

            }, completion: nil)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

        debugPrint("Logging out")
    }

    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    @IBAction func twitterLoginButton(sender: AnyObject) {

        let twitterAuthHelper = TwitterAuthHelper(firebaseRef: DataService.ds.REF_BASE, apiKey:DataService.ds.TwitterAPIKey)

        twitterAuthHelper.selectTwitterAccountWithCallback { error, accounts in
            if error != nil {
                if error.code == -1 {
                    let alert = UIAlertController(title: "Error", message: "Add a Twitter account in Settings", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: { (aAction) in

                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                // Error retrieving Twitter accounts
            } else if accounts.count >= 1 {
                // Select an account. Here we pick the first one for simplicity
                let account = accounts[0] as? ACAccount
                twitterAuthHelper.authenticateAccount(account, withCallback: { error, authData in
                    if error != nil {
                        // Error authenticating account
                    } else {
                        // User logged in!
                        debugPrint(accounts)
                        let twitterData = ["token":authData.token]

                        let imageURL = authData.providerData["profileImageURL"]! as? String
                        let userName = authData.providerData["username"]! as? String
                        let token = authData.token

                        self.saveNewAccount(.facebook, imageURL: imageURL, username: userName, token: token)

                        debugPrint(User.currentUser().Accounts)

                        do {
                            try Locksmith.saveData(twitterData, forUserAccount: twitterAccount)
                            debugPrint("Twitter account added")

                        } catch {
                            debugPrint("Error to save the twitter data")
                        }

                    }
                })
            }
        }
    }

    @IBAction func FbButtonLoginPressed(sender: AnyObject) {
        let facebookLogin  = FBSDKLoginManager()

        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"]) { (result, error) in

            if error != nil {
                debugPrint("Facebook Login Failed")
            } else {

                if !result.isCancelled {
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString

                    DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in

                        if error != nil {
                            debugPrint("Login Failed")
                        } else {
                            debugPrint("Logged In \(authData)")
                            let facebookData = ["token":FBSDKAccessToken.currentAccessToken().tokenString]

                            let imageURL = ""
                            let userName = ""
                            let token = ""

                            self.saveNewAccount(.facebook, imageURL: imageURL, username: userName, token: token)

                            debugPrint(User.currentUser().Accounts)

                            //let firebaseData = ["key":authData.uid]
                            do {
                                try Locksmith.saveData(facebookData, forUserAccount: facebookAccount)
                                //try Locksmith.saveData(firebaseData, forUserAccount: firebaseAccount)
                            } catch {
                                debugPrint("Error to save the facebook data")
                            }
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    })
                } 
            }
        }
    }
}


extension ViewController: GIDSignInUIDelegate,GIDSignInDelegate {

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let imageURL = user.profile.imageURLWithDimension(32).absoluteString
            let userName = user.profile.givenName + user.profile.familyName
            let token = user.authentication.accessToken

            saveNewAccount(.googlePlus, imageURL: imageURL, username: userName, token: token)

            let googleplusData = ["token":user.authentication.accessToken]
            do {
                try Locksmith.saveData(googleplusData, forUserAccount: googlePlusAccount)
                dismissViewControllerAnimated(true, completion: nil)
            } catch {
                debugPrint("Error to save the google plus data")
            }
        } else {
            debugPrint("\(error.localizedDescription)")
        }
    }

    @IBAction func googleplusLoginButtonPressed(sender: AnyObject) {
            GIDSignIn.sharedInstance().signIn()
    }

    private func saveNewAccount(type: socialNetworkType, imageURL: String?, username: String?, token: String?) {
        let account = Account(type: .googlePlus, imageURL: imageURL!, userName: username!, token: token!)

        if User.currentUser().Accounts == nil {
            User.currentUser().Accounts = [account]
        } else {
            User.currentUser().Accounts?.append(account)
        }
    }

}

