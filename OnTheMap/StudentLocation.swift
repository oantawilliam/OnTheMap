//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId = String()
    var uniqueKey = String()
    var createdAt = String()
    var firstName = String()
    var lastName = String()
    var latitude = Double()
    var longitude = Double()
    var mapString = String()
    var mediaURL = String()
    var updatedAt = String()
    
    
    // MARK: Initializers
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        let _objectId = dictionary[ParseClient.JSONResponseKeys.StudentId]
        let _createdAt = dictionary[ParseClient.JSONResponseKeys.CreationDate]
        let _firstName = dictionary[ParseClient.JSONResponseKeys.FirstName]
        let _lastName = dictionary[ParseClient.JSONResponseKeys.LastName]
        let _latitude = dictionary[ParseClient.JSONResponseKeys.Lat]
        let _longitude = dictionary[ParseClient.JSONResponseKeys.Long]
        let _mapString = dictionary[ParseClient.JSONResponseKeys.Place]
        let _mediaURL = dictionary[ParseClient.JSONResponseKeys.Link]
        let _updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdateDate]
        
        self.objectId = _objectId != nil ? _objectId as! String : ""
        self.createdAt = _createdAt != nil ? _createdAt as! String : ""
        self.firstName = _firstName != nil ? _firstName as! String : ""
        self.lastName = _lastName != nil ? _lastName as! String : ""
        self.latitude = _latitude != nil ? _latitude as! Double : 0
        self.longitude = _longitude != nil ? _longitude as! Double : 0
        self.mapString = _mapString != nil ? _mapString as! String : ""
        self.mediaURL = _mediaURL != nil ? _mediaURL as! String : ""
        self.updatedAt = _updatedAt != nil ? _updatedAt as! String : ""
    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Location is a dictionary
        for result in results {
            
            if let firstName = result[ParseClient.JSONResponseKeys.FirstName] as? String,
                let lastName = result[ParseClient.JSONResponseKeys.LastName] as? String,
                let mediaUrl = result[ParseClient.JSONResponseKeys.Link] as? String {
                
                if !firstName.characters.isEmpty && !lastName.characters.isEmpty && !mediaUrl.characters.isEmpty {
                    locations.append(StudentLocation(dictionary: result))
                }
            }
        }
        return locations
    }
}

// MARK: - StudentLocation: Equatable

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.objectId == rhs.objectId
}
