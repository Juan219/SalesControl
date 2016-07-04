//
//  PurchasesTableViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/23/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit
import Foundation

let purchaseCellIdentifier = "PURCHASE_CELL"

class PurchasesTableViewController: UITableViewController {

    private var internalPurchaseCounter: Int?

    var purchases : [Purchase]?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(User.currentUser().userId())

        loadAllPurchases()

        navigationController!.navigationBar.barTintColor = UIColor.darkGrayColor()

        tableView.registerNib(UINib(nibName: "PurchaseCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: purchaseCellIdentifier)
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(purchaseCellIdentifier, forIndexPath: indexPath) as? PurchaseCell

        let currentPurchase = purchases![indexPath.row]


        cell?.productNameLabel.text = currentPurchase.product?.name
        cell?.dateLabel.text = String(currentPurchase.date)
        cell?.vendorNameLabel.text = currentPurchase.product?.vendor?.name
        cell?.quantityLabel.text = String(currentPurchase.product!.quantity!)

        

        return cell!
    }


}

extension PurchasesTableViewController: UserPurchaseDelegate {

    func didFindPurchase(purchase: Purchase) {

        guard purchases == nil else {

            purchases?.append(purchase)

            return
        }

        purchases = [purchase]

        tableView.reloadData()

    }

    func didFinishLoadingPurchases() {
        tableView.reloadData()
    }

    func loadAllPurchases() {

        //dispatch_async(dispatch_get_main_queue(), {
        User.currentUser().purchaseDelegate = self
        User.currentUser().loadAllPurchases()
        //})


    }


}
