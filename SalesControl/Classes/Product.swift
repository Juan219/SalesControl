//
//  Product.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/30/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

protocol ProductDelegate {
    func didFinishParsingProduct(product: Product)
    func didGetVendorImage(vendorImage: UIImage)
}

class Product: NSObject, VendorDelegate {

    var name: String?
    var quantity : Int?
    var vendor: Vendor?

    var delegate: ProductDelegate?

    func parseProduct (data: [String : AnyObject]) {

        self.name = data["name"] as? String
        self.quantity = Int((data["quantity"] as? String)!)!

        let vendor = Vendor()
        vendor.delegate = self
        vendor.parseVendor(data["vendor"] as! [String: AnyObject])
        self.vendor = vendor

    }

    func didFinishDownloadingVendorImage(image: UIImage) {
        self.delegate?.didGetVendorImage(image)
    }

    func didFinishParsingVendor(vendor: Vendor) {
        self.vendor = vendor
        self.delegate?.didFinishParsingProduct(self)
    }

}
