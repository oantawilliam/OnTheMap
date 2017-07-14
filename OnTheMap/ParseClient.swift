//
//  ParseClient.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import Foundation

class ParseClient: RequestsClient {
    
    // MARK: User Data Tasks
    
    func getStudenLocations(_ completionHandlerForGetStudentLocations: @escaping (_ success: Bool?, _ error: NSError?) -> Void) {
        
        let mutableMethod: String = Methods.StudentLocation
        let parameters = [ParseClient.ParameterKeys.MaxLocations: 100,
                          ParseClient.ParameterKeys.Order: "updatedAt"] as [String : Any]
        
        let request = NSMutableURLRequest(url: self.urlFromParameters(parameters as [String : AnyObject], withPathExtension: mutableMethod))
        
        request.addValue(ParseClient.Constants.ApplicationId, forHTTPHeaderField: ParseClient.HeaderFields.ApplicationId)
        request.addValue(ParseClient.Constants.RestApiKey, forHTTPHeaderField: ParseClient.HeaderFields.RestApiKey)

        
        /* 2. Make the request */
        let _ = self.taskForGETMethod(request) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetStudentLocations(nil, error)
            } else {
                
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    StudentLocations.sharedInstance().locations = StudentLocation.locationsFromResults(results)
                    completionHandlerForGetStudentLocations(true, nil)
                } else {
                    completionHandlerForGetStudentLocations(nil, NSError(domain: "getStudenLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudenLocations"]))
                }
            }
        }
    }
    
    func postStudentLocation(_ studentLocation: StudentLocation, completionHandlerForPostLocation: @escaping (_ objectId: String?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let mutableMethod: String = Methods.StudentLocation
        
        let jsonBody = createJsonBodyFromStudentLocation(studentLocation)
        
        let request = createRequestFromMethodAndParamas(method: mutableMethod, parameters: [:])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ParseClient.Constants.ApplicationId, forHTTPHeaderField: ParseClient.HeaderFields.ApplicationId)
        request.addValue(ParseClient.Constants.RestApiKey, forHTTPHeaderField: ParseClient.HeaderFields.RestApiKey)

        
        /* 2. Make the request */
        let _ = self.taskForPOSTMethod(request, jsonBody: jsonBody) { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPostLocation(nil, error)
            } else {
                if let objectId = result?[ParseClient.JSONResponseKeys.StudentId] as? String {
                    completionHandlerForPostLocation(objectId, nil)
                } else {
                    completionHandlerForPostLocation(nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot Add Location"]))
                }
            }
        }
    }
    
    private func createJsonBodyFromStudentLocation(_ studentLocation: StudentLocation) -> String {
        return "{\"uniqueKey\": \"\(studentLocation.uniqueKey)\", \"firstName\": \"\(studentLocation.firstName)\", \"lastName\": \"\(studentLocation.lastName)\",\"mapString\": \"\(studentLocation.mapString)\", \"mediaURL\": \"\(studentLocation.mediaURL)\",\"latitude\": \(studentLocation.latitude), \"longitude\": \(studentLocation.longitude)}"
    }

    private func createRequestFromMethodAndParamas(method: String, parameters: [String:AnyObject]) -> NSMutableURLRequest {
        
        /* 1. Set the parameters */
        
        /* Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: self.urlFromParameters(parameters, withPathExtension: method))
        
        return request
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        Singleton.sharedInstance.scheme = ParseClient.Constants.ApiScheme
        Singleton.sharedInstance.host = ParseClient.Constants.ApiHost
        Singleton.sharedInstance.path = ParseClient.Constants.ApiPath
        
        return Singleton.sharedInstance
    }
}
