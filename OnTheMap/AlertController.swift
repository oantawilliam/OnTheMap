//
//  AlertController.swift
//  OnTheMap
//
//  Created by William Oanta on 14/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation
import UIKit

class AlertController: NSObject {
    
    override init() {
        super.init()
    }
    
    func displayAlertView(viewController: UIViewController, errorString: String) {
        let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func sharedInstance() -> AlertController {
        struct Singleton {
            static var sharedInstance = AlertController()
        }
        
        return Singleton.sharedInstance
    }
}
