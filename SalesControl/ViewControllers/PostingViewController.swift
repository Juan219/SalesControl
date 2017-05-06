//
//  PostingViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 7/30/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//
import UIKit
import Foundation

class PostingViewController: UIViewController {
    var purchase: Purchase?
    var socialNetwork: socialNetworkType?



    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        print("PostingViewController")
    }

    override func viewWillAppear(animated: Bool) {
        //Title
        titleLabel.text = (socialNetwork?.rawValue)!
        //Loading the purchase information.
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
