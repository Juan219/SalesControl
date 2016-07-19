//
//  RequestHelper.swift
//  SalesControl
//
//  Created by Juan Balderas on 7/10/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit
import Alamofire

protocol RequestHelperDelegate {
    func didFinishDownloadingImage(image: UIImage)
}


class RequestHelper: NSObject {

    var delegate : RequestHelperDelegate?

    func dowloadImageAtURL(url: String) {

        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        //request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData

        //let paramString = "data=Hello"
        //request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)

        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in

            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }

            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Data String: \(dataString)")

            self.delegate?.didFinishDownloadingImage(UIImage(data: data!)!)



        }

        task.resume()
    }

}
