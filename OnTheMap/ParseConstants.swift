//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: Credentials
        
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    struct HeaderFields {
        static let ApplicationId = "X-Parse-Application-Id"
        static let RestApiKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        static let PublicUserData = "/StudentLocation/{objectId}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let ObjectID = "objectId"
    }
    
    struct ParameterKeys {
        static let MaxLocations = "limit"
        static let Pagination = "skip"
        static let Order = "order"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
    }
    
    struct JSONResponseKeys {
        
        static let Results = "results"
        
        // MARK: Parse
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Lat = "latitude"
        static let Long = "longitude"
        static let Place = "mapString"
        static let Link = "mediaURL"
        static let StudentId = "objectId"
        static let StudentKey = "uniqueKey"
        static let CreationDate = "createdAt"
        static let UpdateDate = "updatedAt"
    }
}
