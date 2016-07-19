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
    func didFinishLoadingPurchases()
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

    func userId() -> String {
        // look for the id in the NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()

        guard defaults.valueForKey(KEY_UID) == nil  else {
            id = defaults.valueForKey(KEY_UID) as? String

            defaults.setValue(id, forKey: KEY_UID)

            return id!
        }
        id = NSUUID().UUIDString
        do {
        try Locksmith.deleteDataForUserAccount(facebookAccount)
        try Locksmith.deleteDataForUserAccount(twitterAccount)
        try Locksmith.deleteDataForUserAccount(googlePlusAccount) }
        catch {
            print("Error deleting the account Info")
        }

        return id!
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
