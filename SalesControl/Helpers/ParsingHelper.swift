//
//  ParsingHelper.swift
//  SalesControl
//
//  Created by Juan Balderas on 6/28/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

protocol ParsingHelperDelegate {
    func didFinishDownloadingImage(image:UIImage)
    
}

class ParsingHelper: NSObject {

    var delegate: ParsingHelperDelegate?

    func startDownloadingImage(imageUrl: String) {

        var downloadPhotoTask = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string:imageUrl)!) { (url, response, error) in

            guard error != nil else {
                return
            }

            //imageDownloaded

            let image = UIImage(data: NSData(contentsOfURL: url!)!)

            self.delegate?.didFinishDownloadingImage(image!)

        }.resume()


    }

}
