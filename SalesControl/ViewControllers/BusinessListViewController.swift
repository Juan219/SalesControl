//
//  BusinessListViewController.swift
//  SalesControl
//
//  Created by Juan Balderas on 11/19/16.
//  Copyright © 2016 Juan Balderas. All rights reserved.
//

import UIKit

//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise&key=YOUR_API_KEY

class BusinessListViewController: UIViewController {
    var fbBusiness: [Business]?
    var gBusiness: [Business]?
    var cities: [City]?
    var place:GMSPlace?
    var places: [GMSPlace]?
    var businessInCity: Dictionary<String,[Business]>?
    var placesClient: GMSPlacesClient?
    private var keyword: String?
    private var request: RequestHelper?

    @IBOutlet weak var tableView: UITableView!

    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        self.keyword = "restaurant"
        self.gBusiness = [Business]()
        cities = [City]()
        placesClient = GMSPlacesClient()
        getCurrentPlace(UIButton())

    }

    override func viewWillAppear(animated: Bool) {

    }

    private func getBusiness() {
        getGoogleBusiness()
        getFacebookBusiness()
    }

    private func getGoogleBusiness() {
        
    }

    private func getFacebookBusiness() {

    }
    @IBAction func showMap(sender: AnyObject) {

    }

    func getCurrentPlace(sender: UIButton) {


        placesClient?.currentPlaceWithCallback({
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }

            if let placeLicklihoodList = placeLikelihoodList {
                let place = placeLicklihoodList.likelihoods.first?.place
                if let place = place {
                    self.place = place
                    let myCity = City()
                    myCity.latitude = place.coordinate.latitude
                    myCity.longitude = place.coordinate.longitude
                    myCity.name = place.addressComponents![3].name
                    self.cities?.append(myCity)
                    self.tableView.reloadData()
                    self.getListOfPlaces()
                }
            }
        })
    }

    func imageForPlace() {
        placesClient?.lookUpPhotosForPlaceID((self.place?.placeID)!, callback: { (placeMetadata, error) in

        })
    }

    func pickPlace() {
//        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
//        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
//        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
//        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//        let config = GMSPlacePickerConfig(viewport: viewport)
//
//        var placePicker: GMSPlacePicker?
//        placePicker = GMSPlacePicker(config: config)
//
//        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            if let place = place {
//                print("Place name \(place.name)")
//                print("Place address \(place.formattedAddress)")
//                print("Place attributions \(place.attributions)")
//
//            } else {
//                print("No place selected")
//            }
//        })
    }

    func getListOfPlaces() {
        let urlPath: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(self.cities![0].latitude!),\(self.cities![0].longitude!)&keyword=\(keyword!)&radius=500&key=\(googleAPIKey!)"
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        //let queue:NSOperationQueue = NSOperationQueue()
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request1) { (data, response, error) in
            let dicResponse: Dictionary<String,AnyObject>?
            do {
                dicResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? Dictionary<String,AnyObject>
                if let places = dicResponse!["results"] as? [Dictionary<String,AnyObject>] {
                    for place in places {
                        let newPlace = Business()
                        newPlace.name = place["name"] as? String
                        newPlace.address = place["vicinity"] as? String
                        newPlace.placeId = place["id"] as? String
                        newPlace.imagePath = place["icon"] as? String

                        self.gBusiness?.append(newPlace)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })

                }

                print(dicResponse)
            } catch {

            }

        }
        task.resume()


    }

}
extension BusinessListViewController: UITableViewDelegate,UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var items = 0

        if cities?.count > 0 {
            items = (cities?.count)!
        }

        return items
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var items = 0

        if self.gBusiness?.count > 0 {
            items = (self.gBusiness?.count)!
        }

        return items

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let place = self.gBusiness![indexPath.row]
        let placeCell = tableView.dequeueReusableCellWithIdentifier("PLACE_CELL", forIndexPath: indexPath) as? BusinessCell

            placeCell!.nameLabel.text = place.name
            placeCell!.addressLabel.text = place.address
            //placeCell!.workHoursLabel.text = place.ope

            if place.image != nil {
                placeCell!.imageBusinessView.image = place.image
            } else {
                self.request = RequestHelper()
                self.request?.delegate = self
                print("icon:\(place.imagePath)")
                self.request?.dowloadImageAtURL(place.imagePath!, withIdentifier: place.placeId!)
            }

        return placeCell!
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.cities![section].name
    }
}

extension BusinessListViewController: RequestHelperDelegate {
    func didFinishDownloadingImage(image: UIImage, withIndentifier identifier: String) {
        var index = -1
        for place in self.gBusiness! {
            index += 1
            if place.placeId == identifier {

                //self.gBusiness?.removeAtIndex(index)
                place.image = image
                //self.gBusiness?.insert(place, atIndex: index)

                //reload

                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
                })

            }
        }
    }

    func didFinishDownloadingImage(image: UIImage) {

    }
}