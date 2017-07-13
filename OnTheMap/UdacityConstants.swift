//
//  Constants.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "/session"
        static let PublicUserData = "/users/{userId}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "userId"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        // MARK: Udacity
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // MARK: Udacity - Facebook
        static let FacebookMobile = "facebook_mobile"
        static let AccessToken = "access_token"
    }
    
    struct JSONResponseKeys {
        
        // MARK: Account
        static let Account = "account"
        static let AccountState = "registered"
        static let AccountKey = "key"
        
        // MARK: Session
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        // MARK: User Data
        static let User = "user"
        static let LastName = "last_name"
        static let FirstName = "first_name"
    }
}
