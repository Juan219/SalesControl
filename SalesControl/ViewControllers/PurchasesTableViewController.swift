//
//  PurchasesTableViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/23/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit
import Foundation

let purchaseCellIdentifier = "PurchaseCell"

class PurchasesTableViewController: UITableViewController {

    private var internalPurchaseCounter: Int?

    var purchases : [Purchase]?

    override func viewDidLoad() {

        self.setNeedsStatusBarAppearanceUpdate()
        self.preferredStatusBarStyle()
        
        super.viewDidLoad()

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

        loadAllPurchases()

        tableView.registerNib(UINib(nibName: "PurchaseCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: purchaseCellIdentifier)

        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    //MARK: - TableViewsDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = purchases?.count else {
            return 0
        }

        return rows
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Check the cell
        print(tableView.frame.width)
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(purchaseCellIdentifier, forIndexPath: indexPath) as? PurchaseCell

        let currentPurchase = purchases![indexPath.row]

        cell?.productNameLabel.text = currentPurchase.product?.name
        cell?.dateLabel.text = currentPurchase.dateString
        cell?.vendorNameLabel.text = currentPurchase.product?.vendor?.name

        cell?.vendorImageImageView.image = currentPurchase.product?.vendor?.img


        return cell!
    }

    private func getIndexForPurchase(purchaseId:Int) -> Int? {

        //get the index of the purchase based on the purchaseId
        for purchase in purchases! {
            if purchase.id == purchaseId {
                return purchases?.indexOf(purchase)
            }
        }

        return nil
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let postFacebook = UITableViewRowAction(style: .Default, title: "Facebook") { (action, indexPath) in
            //Open postingView for facebook
            let postingFacebook = PostingViewController()

            //performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)

            //self.presentViewController(postingFacebook, animated: true, completion: nil)
        }
        postFacebook.backgroundColor = UIColor.lightGrayColor()
        //postFacebook.backgroundColor = UIColor.imageWithBackgroundColor(UIImage(named: "facebookIcon")!.imageRotatedByDegrees(180, flip: false) , bgColor: UIColor.clearColor())

        //postFacebook.backgroundColor = UIColor.init(patternImage: UIImage(named: "facebook-xl")!)

        let postTwitter = UITableViewRowAction(style: .Default, title: "Twitter") { (action, indexPath) in
            //
        }

        //postTwitter.backgroundColor = UIColor.init(patternImage: UIImage(named: "twitter-xxl")!)
        postTwitter.backgroundColor = UIColor.grayColor()
        //postTwitter.backgroundColor = UIColor.imageWithBackgroundColor(UIImage(named: "twitterIcon")!.imageRotatedByDegrees(180, flip: false) , bgColor: UIColor.clearColor())

        let postGoogle = UITableViewRowAction(style: .Default, title: "Google") { (action, indexPath) in
            //
        }
        postGoogle.backgroundColor = UIColor.darkGrayColor()
        //postGoogle.backgroundColor = UIColor.imageWithBackgroundColor(UIImage(named: "googleplusIcon")!.imageRotatedByDegrees(180, flip: false) , bgColor: UIColor.clearColor())
        //postGoogle.backgroundColor = UIColor.init(patternImage: UIImage(named: "google-plus-512")!)


        return [postGoogle,postTwitter,postFacebook]
    }

}

extension PurchasesTableViewController: UserPurchaseDelegate {

    func didFindPurchase(purchase: Purchase) {

        guard purchases == nil else {

            purchases?.append(purchase)

            return
        }

        purchases = [purchase]

        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: (purchases?.count)!, inSection: 0)], withRowAnimation: .Automatic)

    }

    func loadAllPurchases() {

        User.currentUser().purchaseDelegate = self
        User.currentUser().loadAllPurchases()

    }

    func didLoadVendorImage(image: UIImage, forPurchase purchaseId: Int) {

        let indexPath = [NSIndexPath(forRow: getIndexForPurchase(purchaseId)!, inSection: 0)]

       self.tableView.reloadRowsAtIndexPaths(indexPath, withRowAnimation: .Automatic)

    }

}
