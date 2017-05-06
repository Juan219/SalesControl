//
//  User.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/28/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

protocol UserPurchaseDelegate {
    func didFindPurchase(purchase:Purchase)
    func didLoadVendorImage(image: UIImage, forPurchase purchaseId: Int)
    //func didFinishLoadingPurchases()
}

class User: NSObject {

    private(set) var id: String?
    var Accounts: [Account]?

    private static var _currentUser = User()

    var purchaseDelegate : UserPurchaseDelegate?

    private var parser: ParsingHelper?

    static func currentUser() -> User {
        return _currentUser
    }

    override init() {
        super.init()
        self.loadAccounts()

    }

    func userId() -> String {
        // look for the id in the NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()

        guard defaults.valueForKey(KEY_UID) == nil  else {
            id = defaults.valueForKey(KEY_UID) as? String

            defaults.setValue(id, forKey: KEY_UID)

            return id!
        }
        id = NSUUID().UUIDString
        deleteAccounts()

        return id!
    }

    func deleteAccounts() {
        for account in self.Accounts! {
            self.deleteAccount((account.type?.rawValue)!)
        }
        self.loadAccounts()
    }

    func deleteAccount(account:String) {
        do {
            try Locksmith.deleteDataForUserAccount(account)
        }
        catch let error as NSError {
            print("Error deleting the account Info: \(error)")
        }
    }

    func loadAccounts() {

        deleteAccount(socialNetworkType.twitter.rawValue)
        self.Accounts = [Account]()
        //load facebookAccount
        let fbAccountInfo = Locksmith.loadDataForUserAccount(socialNetworkType.facebook.rawValue)
        //load twitterAccount
        let twAccountInfo = Locksmith.loadDataForUserAccount(socialNetworkType.twitter.rawValue)
        //load googlePlusAccount
        let gpAccountInfo = Locksmith.loadDataForUserAccount(socialNetworkType.googlePlus.rawValue)

        if fbAccountInfo != nil {
            let fbAccount = Account(type: .facebook, imageURL: (fbAccountInfo!["imgURL"] as? String)!, userName: (fbAccountInfo!["userName"] as? String)!, token: (fbAccountInfo!["token"] as? String)!, email: (fbAccountInfo!["email"] as? String)!)
            self.Accounts?.append(fbAccount)
        }
        if twAccountInfo != nil {
            let twAccount = Account(type: .twitter, imageURL: (twAccountInfo!["imgURL"] as? String)!, userName: (twAccountInfo!["userName"] as? String)!, token: (twAccountInfo!["token"] as? String)!, email: (twAccountInfo!["email"] as? String)!)
            self.Accounts?.append(twAccount)
        }
        if gpAccountInfo != nil {
            let imgURL = ((gpAccountInfo!["imgURL"] as? String) != nil) ? gpAccountInfo!["imgURL"] as? String  : ""
            let userName = ((gpAccountInfo!["userName"] as? String) != nil) ? (gpAccountInfo!["userName"] as? String) : ""
            let token = ((gpAccountInfo!["token"] as? String) != nil) ? (gpAccountInfo!["token"] as? String) : ""
            let email = ((gpAccountInfo!["email"] as? String) != nil) ? (gpAccountInfo!["email"] as? String) : ""

            let gpAccount = Account(type: .googlePlus, imageURL: imgURL!, userName: userName!, token: token!, email: email!)
            self.Accounts?.append(gpAccount)
        }

    }

    func loadAllPurchases() {
        
        let purchasesData = getAllPurchasesData()

        let purchases =  purchasesData["purchase"] as? [AnyObject]

        for purchaseJSON: AnyObject in purchases! {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                let purchase = Purchase()
                purchase.delegate = self
                print("New Purchase")
                purchase.parsePurchase(purchaseJSON)
            })
        }

    }
    private func getAllPurchasesData() -> NSDictionary {

        var purchasesData : NSDictionary?

        do {
            let purchasesFile = NSBundle.mainBundle().URLForResource("Purchases", withExtension: "json")
            purchasesData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: purchasesFile!)!, options: .AllowFragments) as? NSDictionary
            
        } catch {
            
        }
        
        return purchasesData!
        
    }

    func isLoggedIn() -> Bool {
        guard Locksmith.loadDataForUserAccount(socialNetworkType.facebook.rawValue) != nil else {
            guard Locksmith.loadDataForUserAccount(socialNetworkType.twitter.rawValue) != nil else {
                guard Locksmith.loadDataForUserAccount(socialNetworkType.googlePlus.rawValue) != nil else {
                    //let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                    //appDelegate?.showLoginScreen()
                    return false
                }
                return true
            }
            return true
        }
        return true
    }
}

extension User: PurchaseDelegate {
    func didParsePurchase(purchase: Purchase) {
        //Return Purchase
        if !NSThread.isMainThread() {
            dispatch_async(dispatch_get_main_queue(), {
                self.purchaseDelegate?.didFindPurchase(purchase)
            })
        } else {
            self.purchaseDelegate?.didFindPurchase(purchase)
        }

    }

    func didGetImageForVendorImage(vendorImage: UIImage, forPurchase vendorId: Int) {
        //Return Id
        if NSThread.isMainThread() {
                self.purchaseDelegate?.didLoadVendorImage(vendorImage, forPurchase: vendorId)
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.purchaseDelegate?.didLoadVendorImage(vendorImage, forPurchase: vendorId)
            })
        }

    }
}
