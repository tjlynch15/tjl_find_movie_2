//
//  Movie.swift
//  Movie App
//
//  Created by terrence lynch on 8/15/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import Foundation



// Creates a movie object for use in TheatersTableViewController. Chose this structure due to nested dictionaries in data source.

class Movie {
    
    
    //MARK: Properties
    
    let title: String
    let imageURL: String
    let showtimes: [Dictionary<String, Any>]
    

    //MARK: Initialization
    
    init?(title: String, imageURL: String, showtimes: [Dictionary<String, Any>]) {
        
        // The name must not be empty
        guard !title.isEmpty else {
            return nil
        }
    
        
        // Initialize stored properties.
        self.title = title
        self.imageURL = imageURL
        self.showtimes = showtimes
       
            }
    
    
    //> Movie Object: title=?, showtimes=?
    func dumpMovieObject() {
        
        print("Movie Object: \(self.title), \(self.imageURL) \(String(describing: self.showtimes))")
        
    }
    
}
