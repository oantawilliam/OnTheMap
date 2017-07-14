//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by William Oanta on 14/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var link: String!
    var location: String!
    var pointAnnotation: MKPointAnnotation!
    var lat: Double!
    var long: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureActivityIndicator()
        self.startLocationSearch()

    }

    private func configureActivityIndicator() {
        
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    private func startLocationSearch() {
        self.activityIndicator.startAnimating()
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = self.location
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                AlertController.sharedInstance().displayAlertView(viewController: self, errorString: "Place Not Found")
                self.activityIndicator.stopAnimating()
                return
            }

            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.location
            
            self.lat = localSearchResponse!.boundingRegion.center.latitude
            self.long = localSearchResponse!.boundingRegion.center.longitude
            
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
            
            self.pointAnnotation.coordinate = coordinate
            let pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            
            self.map.centerCoordinate = self.pointAnnotation.coordinate
            self.map.addAnnotation(pinAnnotationView.annotation!)
            
            // Init the zoom level

            let span = MKCoordinateSpanMake(100, 80)
            let region = MKCoordinateRegionMake(coordinate, span)
            self.map.setRegion(region, animated: true)
            self.activityIndicator.stopAnimating()
            
        }
    }


    @IBAction func onFinish(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userData = appDelegate.userData!
        
        if (pointAnnotation) != nil {
            
            let data = [ParseClient.JSONResponseKeys.FirstName: userData.first_name,
                ParseClient.JSONResponseKeys.LastName: userData.last_name,
                ParseClient.JSONResponseKeys.Link: self.link,
                ParseClient.JSONResponseKeys.Lat: self.lat,
                ParseClient.JSONResponseKeys.Long: self.long,
                ParseClient.JSONResponseKeys.Place: self.location
            ] as [String : AnyObject]
            
            var studentLocation = StudentLocation.init(dictionary: data)
            studentLocation.uniqueKey = UdacityClient.sharedInstance().sessionID!
            
            ParseClient.sharedInstance().postStudentLocation(studentLocation, completionHandlerForPostLocation: { (objectId, error) in
                if error != nil {
                    self.activityIndicator.stopAnimating()
                    AlertController.sharedInstance().displayAlertView(viewController: self, errorString: Constants.InternetOfflineMessage)
                } else {
                    self.goToMapView()
                }
            })

        }
    }
    
    func goToMapView() {
        self.activityIndicator.stopAnimating()
        dismiss(animated: true, completion: nil)
    }
}
