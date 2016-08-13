//
//  Vendor.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/23/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit


enum socialNetworkType: String {
    case facebook = "facebook"
    case twitter = "twitter"
    case googlePlus = "googlePlus"
}

protocol VendorDelegate {
    func didFinishParsingVendor(vendor: Vendor)
    func didFinishDownloadingVendorImage( image: UIImage)
}

class Vendor: NSObject, RequestHelperDelegate {

    var id: Int?
    var name: String?
    var imgUrl:String?
    var img : UIImage?

    var delegate :  VendorDelegate?
    private var requester : RequestHelper?

    func parseVendor(data: [String : AnyObject]) {


        self.id = data["id"] as? Int
        self.imgUrl = data["imgURL"] as? String
        self.name = data["name"] as? String
        requester = RequestHelper()
        requester?.delegate = self
        
        requester?.dowloadImageAtURL(self.imgUrl!)

        delegate?.didFinishParsingVendor(self)
    }

    func didFinishDownloadingImage(image: UIImage) {
        self.img = image
        delegate?.didFinishDownloadingVendorImage(image)
    }

    func didFinishDownloadingImage(image: UIImage, withIndentifier identifier: String) {
        //
    }

    

}
