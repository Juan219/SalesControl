//
//  AddPurchaseViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 7/21/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//


class AddPurchaseViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var floatingView: UIView!


    override func viewDidLoad() {

        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.layer.borderWidth = 1

        floatingView.layer.borderColor = UIColor.whiteColor().CGColor
        floatingView.layer.borderWidth = 1
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
