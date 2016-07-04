//
//  DataService.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/22/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import Foundation
import Firebase




class DataService {
    static let ds = DataService()

    private let _REF_BASE = Firebase(url: "https://salescontrol.firebaseio.com/")
    private let _twitterAPIKey = "sVsOaASov1eZDkYqfC2XSOWHG"

    var REF_BASE: Firebase {
        return _REF_BASE
    }

    var TwitterAPIKey: String {
        return _twitterAPIKey
    }


}
