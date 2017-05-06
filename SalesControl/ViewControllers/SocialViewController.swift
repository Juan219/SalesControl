//
//  SocialViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 11/20/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController {
    var fbUsers: [AnyObject]?
    var gUsers: [AnyObject]?

    override func viewDidLoad() {
        fbUsers = [AnyObject]()
        gUsers = [AnyObject]()
        getData()
    }

    private func getfbUsers() {
        //Obtener los usuarios de facebook
        var request = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);

        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                print("Friends are : \(result)")
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }

    private func getgUsers() {

    }

    private func getData() {
        getgUsers()
        getfbUsers()
    }

}

extension SocialViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (fbUsers?.count)!
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}