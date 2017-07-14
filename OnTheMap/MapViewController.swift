//
//  MapViewController.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: OnMapViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadMap()
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onAddPinPressed(_ sender: Any) {
        self.goToAddLocationView()
    }
    @IBAction func onLogoutPressed(_ sender: Any) {
        self.logout()
    }
    
    @IBAction func onRefreshPressed(_ sender: Any) {
        self.reloadMap()
    }
    
    // MARK: - Data Access
    
    func reloadMap() {
        self.activityIndicator.startAnimating()
        self.getStudentLocations { success in
            
            var annotations = [MKPointAnnotation]()
            for studentLocation in StudentLocations.sharedInstance().locations {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(studentLocation.latitude)
                let long = CLLocationDegrees(studentLocation.longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                annotation.subtitle = studentLocation.mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
                
                performUIUpdatesOnMain {
                    self.map.addAnnotations(annotations)
                    self.activityIndicator.stopAnimating()
                }
            }
            
        }
    }
}
