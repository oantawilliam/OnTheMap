//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by William Oanta on 14/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    
    // MARK: Actions
    @IBAction func onCancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func onFindLocation(_ sender: Any) {
        let location = self.location.text!
        let link = self.link.text!
        
        if Validator.isUrlValid(urlString: link){
            self.goToFindLocationView(location, link)
        } else {
            AlertController.sharedInstance().displayAlertView(viewController: self, errorString: AppConstants.InvalidURLMessage)
        }
    }
    
    private func goToFindLocationView(_ location: String, _ link: String) {
        let findLocationViewController = storyboard!.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        
        findLocationViewController.location = location
        findLocationViewController.link = link
    
        self.navigationController!.pushViewController(findLocationViewController, animated: true)
    }
}
