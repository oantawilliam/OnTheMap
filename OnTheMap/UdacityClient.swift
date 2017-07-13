//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: RequestsClient {
    
    // authentication state
    var sessionID: String? = nil
    
    // MARK: Authentication Tasks
    
    func authenticateWithViewController(email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.getSessionID(email, password: password) { (sessionID, errorString) in
            if let sessionID = sessionID {
                self.sessionID = sessionID
                
                self.getUserData(self.sessionID!, completionHandlerForGetUserData: { (userData, error) in
                    if let error = error {
                        completionHandlerForAuth(false, error.localizedDescription)
                    } else {
                        completionHandlerForAuth(true, nil)
                    }
                })
        
            } else {
                completionHandlerForAuth(false, errorString?.localizedDescription)
            }
        }
    }
    
    func deleteSession(completionHandlerForDeleteSession: @escaping (_ sessionID: String?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: self.urlFromParameters([:], withPathExtension: Methods.Session))
        
        /* 2. Make the request */
        let _ = self.taskForDELETEMethod(request) { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForDeleteSession(nil, error)
            } else {

                if let session = result?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject], let id = session[UdacityClient.JSONResponseKeys.SessionID] as? String {
                    self.sessionID = nil
                    completionHandlerForDeleteSession(id, nil)
                } else {
                    completionHandlerForDeleteSession(nil, NSError(domain: "deleteSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not delete Session"]))
                }
                
            }
        }
    }
    
    func getSessionID(_ email: String, password: String, completionHandlerForGetSessionID: @escaping (_ sessionID: String?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = Methods.Session
        
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(email)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        let request = NSMutableURLRequest(url: self.urlFromParameters(parameters, withPathExtension: mutableMethod))
        
        /* 2. Make the request */
        let _ = self.taskForPOSTMethod(request, jsonBody: jsonBody) { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetSessionID(nil, error)
            } else {
                if let account = result?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject], let registered = account[UdacityClient.JSONResponseKeys.AccountState] as? Bool,
                    registered {
                    if let id = account[UdacityClient.JSONResponseKeys.AccountKey] as? String {
                        completionHandlerForGetSessionID(id, nil)
                    } else {
                        completionHandlerForGetSessionID(nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Session ID not Available"]))
                    }
                } else {
                    completionHandlerForGetSessionID(nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Account not found or invalid credentials"]))
                }
            }
        }
    }
    
    func getUserData(_ sessionID: String, completionHandlerForGetUserData: @escaping (_ userData: UserData?, _ error: NSError?) -> Void) {
        
        var mutableMethod: String = Methods.PublicUserData
        
        mutableMethod = super.substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: sessionID)!
        
        
        let request = NSMutableURLRequest(url: self.urlFromParameters([:], withPathExtension: mutableMethod))
        
        /* 2. Make the request */
        let _ = self.taskForGETMethod(request) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetUserData(nil, error)
            } else {
                
                if let results = results?[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
                    
                    if let lastName = results[UdacityClient.JSONResponseKeys.LastName],
                        let firstName = results[UdacityClient.JSONResponseKeys.FirstName] {
                        
                            let userData = UserData(last_name: lastName as! String, first_name: firstName as! String)
                        
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userData = userData
                            completionHandlerForGetUserData(userData, nil)
                    } else {
                        completionHandlerForGetUserData(nil, NSError(domain: "getUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse user info"]))
                    }
                } else {
                    completionHandlerForGetUserData(nil, NSError(domain: "getUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getUserData"]))
                }
            }
        }
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        Singleton.sharedInstance.scheme = UdacityClient.Constants.ApiScheme
        Singleton.sharedInstance.host = UdacityClient.Constants.ApiHost
        Singleton.sharedInstance.path = UdacityClient.Constants.ApiPath
        
        return Singleton.sharedInstance
    }
}
