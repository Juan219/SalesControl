//
//  ParsingHelper.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/28/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

protocol ParsingHelperDelegate {
    func didFinishDownloadingImage(image:UIImage, forIndex index:NSIndexPath)
    //optional func didFinishLoadingAllPurchasesWithError(error:NSError)
}

class ParsingHelper: NSObject {

    var delegate: ParsingHelperDelegate?

    func startDownloadingImage(imageUrl: String, atIndex index:NSIndexPath) {

        let image = UIImage(contentsOfFile: "")

        delegate?.didFinishDownloadingImage(image!, forIndex: index)
    }

}
