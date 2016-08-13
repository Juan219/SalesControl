//
//  Account.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/28/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class Account: NSObject {

    var type : socialNetworkType?
    var imageURL : String?
    var userName : String?
    var token : String?
    var email: String?

    init(type: socialNetworkType, imageURL: String, userName: String, token: String) {

        self.type = type
        self.imageURL = imageURL
        self.userName = userName
        self.token = token

    }

    convenience init(type: socialNetworkType, imageURL: String, userName: String, token: String, email: String) {
        self.init(type: type, imageURL: imageURL, userName: userName, token: token)
        self.email = email
    }

}
