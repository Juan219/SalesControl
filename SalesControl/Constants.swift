//
//  Constants.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/22/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import Foundation

let KEY_UID = "uid"
let defaults = NSUserDefaults.standardUserDefaults()

let googlePath = NSBundle.mainBundle().pathForResource("GoogleService-Info", ofType: "plist")
let dict = NSDictionary(contentsOfFile: googlePath!)

//.plist values
let googleAPIKey = dict?.valueForKey("API_KEY")

//MARK: - Accounts
let facebookAccount = "facebook"
let twitterAccount = "twitter"
let googlePlusAccount = "googlePlus"
let firebaseAccount = "firebase"
//MARK: - StoreData Constants
let cUserName = "userName"
let cToken = "token"
let cEmail = "email"
let cType = "type"
let cImageUrl = "imageURL"
//MARK: - Colors

//Negro
let appColorNegro = UIColor(red: 23/255, green: 32/255, blue: 42/255, alpha: 1.0)
//Azul
let appColorAzul = UIColor(red: 46/255, green: 64/255, blue: 83/255, alpha: 1.0)
//Azul Marino
let appColorAzulMarino = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)




//MARK: - Segue
