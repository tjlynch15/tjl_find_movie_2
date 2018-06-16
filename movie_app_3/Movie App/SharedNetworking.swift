//
//  SharedNetworking.swift
//  Movie App
//
//  Created by terrence lynch on 8/10/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit


// Shared networking class for networking calls to The Movie DataBase and Gracenote Developer

class SharedNetworking {
    
    //
    static let sharedInstance = SharedNetworking()
    
    
    fileprivate init() {} //This prevents others from using the default '()' initializer for this class.
    
    ///
    
    // - Attribution: "https://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    
    func getIssues(url: String, completion:@escaping ([[String: AnyObject]]?) -> Void) {
        
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            fatalError("Unable to create NSURL from string")
        }
        
        // Create a vanilla url session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                
                self.failureAlert()
                
                return
            }
            
            // Print out the response (for debugging purpose)
            //print("Response: \(String(describing: response))")
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                fatalError("Error: \(error!.localizedDescription)")
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                fatalError("Data is nil")
            }
            
            // We received raw data, print it out for debugging
            // It needs to be converted to JSON
            //print("Raw data: \(data)")
            
            // Serialize the raw data into JSON using `NSJSONSerialization`.  The "do-let" is
            // part of
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                //print(json!)
                
                // Cast JSON as an array of dictionaries
                //guard let issues = json as? [["RelatedTopics": [String: AnyObject]]] else {
                guard let issues = json?["results"] as? [[String: AnyObject]] else {
                    
                    fatalError("We couldn't cast the JSON to an array of dictionaries")
                }
                
                // Call the completion block closure and pass the issues array of dictionaries as the argument to the
                // completion block.  This means that the code executed as part of the
                // completion block will have access to the `issues` data
                completion(issues)
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }
    
    func showNetworkIndicator() -> Void {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func hideNetworkIndicator() -> Void {
        
        DispatchQueue.main.async { // Correct
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    // Present alert if no internet connection
    // Attribution: - https://stackoverflow.com/questions/26554894/how-to-present-uialertcontroller-when-not-in-a-view-controller
    
    func failureAlert() -> Void {
        
        print("error != nil")
        
        let alert:UIAlertController = UIAlertController(title: "Error", message: "Connection Failed", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            
            print("navigation controller")
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            
            print("tabBar controller")
            rootViewController = tabBarController.selectedViewController
        }
        
        rootViewController?.present(alert, animated: true, completion: nil)
        
        print("error != nil 2")
    }
    
    
    
    func getIssues2(url: String, completion:@escaping ([[String: AnyObject]]?) -> Void) {
        
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            fatalError("Unable to create NSURL from string")
        }
        
        // Create a vanilla url session
        let session = URLSession.shared
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                
                self.failureAlert()
                
                return
            }
            
            // Print out the response (for debugging purpose)
            //print("Response: \(String(describing: response))")
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                fatalError("Error: \(error!.localizedDescription)")
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                fatalError("Data is nil")
            }
            
            // We received raw data, print it out for debugging
            // It needs to be converted to JSON
            //print("Raw data: \(data)")
            
            // Serialize the raw data into JSON using `NSJSONSerialization`.  The "do-let" is
            // part of
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(json!)
                
                // Cast JSON as an array of dictionaries
                //guard let issues = json as? [["RelatedTopics": [String: AnyObject]]] else {
               
                guard let issues = json as? [[String: AnyObject]] else {
                    
                   
                    
                    fatalError("We couldn't cast the JSON to an array of dictionaries")
                }
                
                // Call the completion block closure and pass the issues array of dictionaries as the argument to the
                // completion block.  This means that the code executed as part of the
                // completion block will have access to the `issues` data
                completion(issues)
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }
    
    
    
}












