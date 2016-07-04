//
//  Purchase.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/22/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit
protocol PurchaseDelegate {
    func didParsePurchase(purchase: Purchase)
}

class Purchase: NSObject {
    var id: Int?
    var product: Product?
    var date: NSDate?



    class func parsePurchase (data: [String : AnyObject]) -> Purchase {
        
        let newPurchase = Purchase()

        newPurchase.id = data["id"] as? Int
        newPurchase.product = Product.parseProduct(data["product"] as! [String: AnyObject])
        debugPrint(newPurchase.product.debugDescription)
        newPurchase.date = data["date"] as? NSDate
        
        return newPurchase
    }
    
}

