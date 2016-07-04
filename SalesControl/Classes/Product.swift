//
//  Product.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/30/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class Product: NSObject {

    var name: String?
    var quantity : Int?
    var vendor: Vendor?

    class func parseProduct (data: [String : AnyObject]) -> Product {

        let newProduct = Product()

        newProduct.name = data["name"] as? String
        newProduct.quantity = Int((data["quantity"] as? String)!)!
        newProduct.vendor = Vendor.parseVendor(data["vendor"] as! [String: AnyObject])
        

        return newProduct

    }

}
