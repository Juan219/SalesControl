//
//  AccountCell.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/22/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblSocialNetwork: UILabel!

    @IBOutlet weak var interView: UIView!
    var activityView: UIActivityIndicatorView?


    override func awakeFromNib() {
        activityView = UIActivityIndicatorView()
        print("cell awake from nib")
        interView.layer.cornerRadius = 5
        interView.clipsToBounds = true
        interView.layer.borderWidth = 1;
        interView.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didMoveToSuperview() {
        activityView?.frame  = imgUserProfile.frame
        activityView?.activityIndicatorViewStyle = .WhiteLarge
        activityView?.startAnimating()

        self.addSubview(activityView!)
    }

    func stopAnimating() {
        activityView?.stopAnimating()
        activityView?.removeFromSuperview()
    }

}
