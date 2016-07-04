//
//  Vendor.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/23/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit


enum socialNetworkType {
    case facebook
    case twitter
    case googlePlus
}

class Vendor: NSObject {

    var id: Int?
    var name: String?
    var imgUrl:String?


    class func parseVendor (data: [String : AnyObject]) -> Vendor {
        let newVendor = Vendor()

        newVendor.id = data["id"] as? Int
        newVendor.imgUrl = data["imgURL"] as? String
        newVendor.name = data["name"] as? String

        return newVendor

    }

    

}
