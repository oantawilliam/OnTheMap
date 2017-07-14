//
//  OnMapViewController.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class OnMapViewController: UIViewController {

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
    
    func getStudentLocations(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        ParseClient.sharedInstance().getStudenLocations { (success, errorString) in
            if let success = success, success {
                completionHandler(true)
            } else {
                self.activityIndicator.stopAnimating()
                self.displayError(AppConstants.InternetOfflineMessage)
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
                self.activityIndicator.stopAnimating()
                self.displayError(AppConstants.InternetOfflineMessage)
            }
        }
    }
    
    func goToAddLocationView() {
        let addLocationViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.navigationController!.pushViewController(addLocationViewController, animated: true)
    }
    
    private func completeLogoutAction() {
        self.activityIndicator.stopAnimating()
        dismiss(animated: true, completion: nil)
    }
}
