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


    override func awakeFromNib() {

//        self.frame.size = CGSize(width: self.frame.width + actionViewWidth, height: self.frame.height)
//
//        //Add the view with the actions
//        let actionView = UIView(frame: CGRectMake(CGRectGetWidth(self.frame) - actionViewWidth, self.frame.origin.y, self.actionViewWidth, CGRectGetHeight(self.frame)))
//        print(actionView.frame)
//        print(self.frame)
//        actionView.backgroundColor = UIColor.blackColor()
//        self.backgroundColor = UIColor.redColor()
//        self.addSubview(actionView)
//
//        scrollView.contentSize = self.frame.size
//        scrollView.pagingEnabled = true
//
//        let amount = 100
//
//        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
//        horizontal.minimumRelativeValue = -amount
//        horizontal.maximumRelativeValue = amount
//
//        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
//        vertical.minimumRelativeValue = -amount
//        vertical.maximumRelativeValue = amount
//
//        let group = UIMotionEffectGroup()
//        group.motionEffects = [horizontal, vertical]
//        self.addMotionEffect(group)

    }

}
