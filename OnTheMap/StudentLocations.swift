//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by William Oanta on 14/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation

class StudentLocations {
    var locations: [StudentLocation] = [StudentLocation]()
    
    class func sharedInstance() -> StudentLocations {
        struct Singleton {
            static var sharedInstance = StudentLocations()
        }
        
        return Singleton.sharedInstance
    }
}
