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

    @IBOutlet weak var tableView: UITableView!
    

    var timer : NSTimer?
    private var uuid: String?
    var requester: RequestHelper?

    @IBOutlet weak var doneButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        //doneButton.hidden = true

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        //TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self

        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(animateButtons), userInfo: nil, repeats: true)

    }

    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    override func viewWillAppear(animated: Bool) {
        if (User.currentUser().isLoggedIn() == true) {
            self.doneButton.hidden = false
        }
        User.currentUser().deleteAccounts()
        animateButtons()
        checkAccounts()

    }

    func checkAccounts() {
        for account in User.currentUser().Accounts! {
            let type = socialNetworkType(rawValue: (account.type?.rawValue)!)
            switch type! {
            case .facebook :
                self.facebookLoginButton.hidden = true
                break
            case .twitter:
                self.twitterLoginButton.hidden = true
                break
            case .googlePlus:
                self.googleplusLoginButton.hidden = true
                break
                //
            }
        }
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
        //Check if is logged in with an Account
        if User.currentUser().isLoggedIn() == true {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            //self.animate(self.facebookLoginButton)
        }
    }

    func animate(button:UIButton) {
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)
        print(button)
        UIView.animateWithDuration(0.4, animations: {
            button.frame = CGRectMake(10, 10,60,60)
            button.hidden = true
        })


        print(button)
        self.view.layoutIfNeeded()
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

                        let imageURL = authData.providerData["profileImageURL"]! as? String
                        let userName = authData.providerData["username"]! as? String
                        let email = ""//authData.providerData["email"] as? String
                        let token = authData.token

                        self.saveNewAccount(.twitter, imageURL: imageURL, username: userName, token: token,email: email)
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

                            let imageURL = authData.providerData["profileImageURL"]! as? String
                            let userName = authData.providerData["username"]! as? String
                            let email = authData.providerData["email"] as? String
                            let token = authData.token

                            self.saveNewAccount(.facebook, imageURL: imageURL, username: userName, token: token,email: email)

                            debugPrint(User.currentUser().Accounts)
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
            let email = user.profile.email
            let token = user.authentication.accessToken

            saveNewAccount(.googlePlus, imageURL: imageURL, username: userName, token: token, email: email)

        } else {
            debugPrint("\(error.localizedDescription)")
        }
    }

    @IBAction func googleplusLoginButtonPressed(sender: AnyObject) {
            GIDSignIn.sharedInstance().signIn()
    }

    private func saveNewAccount(type: socialNetworkType, imageURL: String?, username: String?, token: String?, email:String?) {
        let account = Account(type: type, imageURL: imageURL!, userName: username!, token: token!,email: email!)

        if User.currentUser().Accounts == nil {
            User.currentUser().Accounts = [account]
        } else {
            User.currentUser().Accounts?.append(account)
        }
        let data: [String:AnyObject] = ["imageURL":imageURL!, "userName":username!,"token":token!,"email":email!,"type":type.rawValue]

        do {
            let accountData = Locksmith.loadDataForUserAccount(type.rawValue)
            if accountData != nil {
                try Locksmith.updateData(data, forUserAccount: type.rawValue)
            } else {
                try Locksmith.saveData(data, forUserAccount: type.rawValue)
            }
        } catch (let error as NSError) {
             debugPrint("Error to save the \(type.rawValue) data \(error.localizedDescription)")
        }

        self.tableView.reloadData()
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource,RequestHelperDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if (User.currentUser().Accounts != nil) {
            rows = (User.currentUser().Accounts?.count)!
        }
        return  rows
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: AccountCell = tableView.dequeueReusableCellWithIdentifier("ACCOUNT_CELL") as! AccountCell

        let account = User.currentUser().Accounts![indexPath.row]

        cell.lblSocialNetwork.text = account.type.debugDescription
        //cell.lblUserEmail.text =

        requester = RequestHelper()
        requester?.delegate = self
        requester?.dowloadImageAtURL(account.imageURL!)

        return cell

    }

    func didFinishDownloadingImage(image: UIImage) {

    }

    func didFinishDownloadingImage(image: UIImage, withIndentifier identifier: String) {
        //get the cell for identifier
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(identifier)!, inSection: 0)) as! AccountCell

        cell.imgUserProfile.image = image

    }
}



