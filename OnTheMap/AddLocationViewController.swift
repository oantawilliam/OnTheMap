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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFindLocation(_ sender: Any) {
        let location = self.location.text!
        let link = self.link.text!
        
        if Validator.isUrlValid(urlString: link){
            self.goToFindLocationView(location, link)
        } else {
            AlertController.sharedInstance().displayAlertView(viewController: self, errorString: "Please enter a valid URL!")
        }
    }
    
    private func goToFindLocationView(_ location: String, _ link: String) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        
        controller.location = location
        controller.link = link
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
