//
//  EmailValidator.swift
//  OnTheMap
//
//  Created by William Oanta on 14/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation
import UIKit

class Validator: NSObject {
    
    static func isUrlValid (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

    static func isEmailAddressValid(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch {
            returnValue = false
        }
        
        return  returnValue
    }
}
