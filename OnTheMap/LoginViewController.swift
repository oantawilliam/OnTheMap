//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // MARK: - Actions
    
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

    @IBAction func onLogin(_ sender: Any) {
        
        let email = self.email.text!
        let password = self.password.text!
        
        if Validator.isEmailAddressValid(emailAddressString: email) {
            self.continueLoginProcess(email: email, password: password)
        } else {
            AlertController.sharedInstance().displayAlertView(viewController: self, errorString: AppConstants.InvalidEmailMessage)
        }
    }
    
    func continueLoginProcess(email: String, password: String) {
        self.activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance().authenticateWithViewController(email: email, password: password) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.activityIndicator.stopAnimating()
                    self.displayError(errorString)
                }
            }
        }
    }

    @IBAction func onSignUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: AppConstants.UdacityURL)!)
    }
    
    private func completeLogin() {
        self.activityIndicator.stopAnimating()
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapAndTableTabbedView") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String?) {
        AlertController.sharedInstance().displayAlertView(viewController: self, errorString: errorString!)
    }
    
}

