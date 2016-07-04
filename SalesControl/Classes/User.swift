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

        return id!
    }

    func loadAllPurchases() {
        do {
            let purchasesData = getAllPurchasesData()

            let purchases = purchasesData["purchase"] as! [[String: AnyObject]]

            for purchaseDic in purchases {

                self.purchaseDelegate?.didFindPurchase(Purchase.parsePurchase(purchaseDic))

            }

            self.purchaseDelegate?.didFinishLoadingPurchases()


        } catch {

            print("error")

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
