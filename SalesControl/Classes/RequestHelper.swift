//
//  RequestHelper.swift
//  SalesControl
//
//  Created by Juan Balderas on 7/10/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit
import Alamofire

enum requestType: String {
    case googleBusiness = "google/Business"
    case facebookBusiness = "facebook/Business"
}

protocol RequestHelperDelegate {
    func didFinishDownloadingImage(image: UIImage)
    func didFinishDownloadingImage(image: UIImage, withIndentifier identifier:String)
}


class RequestHelper: NSObject {

    var delegate : RequestHelperDelegate?

    func dowloadImageAtURL(url: String) {

        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

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

    func dowloadImageAtURL(url: String, withIdentifier identifier:String) {
        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        if let image = getImage(identifier) {
            self.delegate?.didFinishDownloadingImage(image, withIndentifier: identifier)
        } else {

        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in

            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }

            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let image = UIImage(data: data!)!
            print("Data String: \(dataString)")
            self.delegate?.didFinishDownloadingImage(image, withIndentifier: identifier)
            dispatch_async(dispatch_get_main_queue(), {
                self.saveImage(image, withName: identifier)
            })
        }
        
        task.resume()
        }
    }

    private func saveImage(image:UIImage,withName name:String) {
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent(name)
            print("SaveImage: \(filename)")
            data.writeToFile(filename, atomically: true)
        }
    }

    private func getImage(name:String) -> UIImage? {
        let fileName = getDocumentsDirectory().stringByAppendingPathComponent(name);
            print("getImage: \(fileName)")
        let image = UIImage(contentsOfFile: fileName)
        return image
    }

    private func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func getGoogleBusiness() {
        
    }

}
