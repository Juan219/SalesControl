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
    func didGetImageForVendorImage(vendorImage: UIImage, forPurchase vendorId:Int)
}

class Purchase: NSObject, ProductDelegate {
    var id: Int?
    var product: Product?
    private let dateFormatter = NSDateFormatter()
    private var date : NSDate?
    var delegate: PurchaseDelegate?

    var dateString: String {
        get {
            //return String(date!).substringToIndex(String(date!).startIndex.advancedBy(10))

            let string = String(date!)

            return (string[string.startIndex.advancedBy(5)...string.startIndex.advancedBy(10)]).stringByReplacingOccurrencesOfString("-", withString: "/")
        }
        set {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.dateFromString(newValue)
        }
    }

    func parsePurchase (data: AnyObject) {

        self.id = Int(data["id"] as! String)
        print(self.id)
        let product = Product()
        
        product.delegate = self
        product.parseProduct(data["product"] as! [String: AnyObject])
        
        guard data["date"] != nil else {

            return
        }

        self.dateString = data["date"] as! String

    }

    func didFinishParsingProduct(product: Product) {
        //return Product
        self.product = product
        print("Finish Parsing purchase:\(self.id)")
        self.delegate?.didParsePurchase(self)

    }

    func didGetVendorImage(vendorImage: UIImage) {
        //return Image
        delegate?.didGetImageForVendorImage(vendorImage, forPurchase: self.id!)
    }
    
}

