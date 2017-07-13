//
//  OnMapViewController.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class OnMapViewController: UIViewController {

    var locations: [StudentLocation] = [StudentLocation]()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        self.configureActivityIndicator()
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
    
    func getStudentLocations(_ completionHandler: @escaping (_ result: [StudentLocation]?) -> Void) {
        ParseClient.sharedInstance().getStudenLocations { (locations, errorString) in
            if let locations = locations {
                self.locations = locations
                completionHandler(self.locations)
            } else {
                self.displayError(errorString?.localizedDescription)
            }
        }
    }
    
    private func displayError(_ errorString: String?) {
        AlertController.sharedInstance().displayAlertView(viewController: self, errorString: errorString!)
    }

    func logout() {
        self.activityIndicator.startAnimating()
        UdacityClient.sharedInstance().deleteSession { (sessionID, errorString) in
            if sessionID != nil {
                performUIUpdatesOnMain {
                    self.completeLogoutAction()
                }
            } else {
                self.displayError(errorString?.localizedDescription)
            }
        }
    }
    
    private func completeLogoutAction() {
        self.navigationController?.viewControllers.removeAll()
        
        self.activityIndicator.stopAnimating()
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        present(controller, animated: true, completion: nil)
    }
}