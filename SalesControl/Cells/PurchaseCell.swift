//
//  PurchaseCell.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/22/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit



class PurchaseCell: UITableViewCell {

    @IBOutlet weak var vendorImageImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!

    private let actionViewWidth : CGFloat = 30.0
    var purchase : Purchase?

}
