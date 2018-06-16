//
//  TopRatedTableViewController.swift
//  Movie App
//
//  Created by terrence lynch on 8/11/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit

class TopRatedTableViewController: UITableViewController {

    /// The array of dictionaries that will hold all moview
    /// data returned from the network request
    var issues:[[String: AnyObject]]?
    
    var dictionaryArray = [Dictionary<String, String>]()
    
    let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=4cccd6917c9ed5fd7472f9b5d2d95df6&language=en-US&page=1"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        print("TopRated ViewDidLoad")
        
        SharedNetworking.sharedInstance.showNetworkIndicator()
        
        SharedNetworking.sharedInstance.getIssues(url: urlString) { (issues) in
            
            self.createDictionary(issues: issues!)
            
            // The data is available in this closure through the `issues` variable
            
            // Copy the `issues` to a property of the view controller so that it can
            // persist beyond the closure block.  The property should
            // be of the same type as the parameter here (eg [[String: AnyObject]]?)
            
            // Reload the table.  The tables data source should be the property you copied the
            // issues to (above). Remember to refresh the table on the main thread
            
            DispatchQueue.main.async {
                // Anything in here is execute on the main thread
                // You should reload your table here.
                
                self.tableView.reloadData()
            }
            
            // For debugging
            //print(issues as Any)
            
            SharedNetworking.sharedInstance.hideNetworkIndicator()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dictionaryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TopRatedTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TopRatedTableViewCell  else {fatalError("The dequeued cell is not an instance of TopRatedTableViewCell.")
        }
        
        // Fetches the appropriate issue for the data source layout.
        let issue = dictionaryArray[indexPath.row]
        
        cell.topRatedTitle.text = issue["title"]
        cell.topRatedReleaseDate.text = issue["release_date"]
        
        downloadImage(posterPath: issue["poster_path"]!, index: indexPath.row) { (thumbImage) in
            cell.movieImage.image = thumbImage
        }
        
        return cell
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let trdvc = segue.destination as? TRDescriptionViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedCell = sender as? TopRatedTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        trdvc.passedTitle = dictionaryArray[indexPath.row]["title"]!
        trdvc.passedMovieId = dictionaryArray[indexPath.row]["movieId"]!
        trdvc.passedPosterPath = dictionaryArray[indexPath.row]["poster_path"]!
        trdvc.passedOverview = dictionaryArray[indexPath.row]["overview"]!
    }
    
    
    func createDictionary(issues: [[String: AnyObject]]) {
        
        let numIssues = issues.count
        print("TopRated numIssues: \(numIssues)")
        
        print()
        
        var issueDictionary: [String:String] = [:]
        
        dictionaryArray = [Dictionary<String, String>]()
        
        var title = ""
        var movieId = ""
        var releaseDate = ""
        var poster_path = ""
        var overview = ""
        
        for index in 0..<numIssues {
            
            // access all objects in array
            
            if (issues[index]["title"] != nil) {
                
                title = (issues[index]["title"] as! String)
                
                movieId = issues[index]["id"] != nil ?  "\(issues[index]["id"]!)" : ""
                //print(movieId)
                
                releaseDate = (issues[index]["release_date"] as! String)
                
                let convertedReleaseDate = convertDate(date: releaseDate)
                
                poster_path = (issues[index]["poster_path"] as! String)
                overview = (issues[index]["overview"] as! String)
                
                issueDictionary = ["title": title, "movieId": movieId, "release_date": convertedReleaseDate, "poster_path":poster_path, "overview": overview]
                dictionaryArray.append(issueDictionary)
                
            }
        }
        //print("TopRated")
        //print(dictionaryArray)
        //print("dictionaryArray count: \(dictionaryArray.count)")
    }
    
    
    
    func convertDate (date: String) -> String {
        
        let dateString = date
        
        let dateFormatter = DateFormatter()
        
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let someDateTime = dateFormatter.date(from: dateString)
        
        dateFormatter.dateStyle = .medium
        
        let newDate = dateFormatter.string(from: someDateTime!)
        
        return newDate
    }

    
    
    // Attribution: - https://stackoverflow.com/questions/39813497/swift-3-display-image-from-url
    
    func downloadImage(posterPath: String, index: Int, completion: @escaping (UIImage) -> Void) {
        
        var image = UIImage()
        
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w300" + posterPath)
        print("poster url: \(String(describing: posterURL))")
        
        
        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)
        
        
        // Define a download task. The download task will download the contents of the URL as a Data object.
        let downloadPicTask = session.dataTask(with: posterURL!) { (data, response, error) in
            // The download has finished.
            if let e = error {
                
                self.connectionFailed()
                
                print("Error downloading picture: \(e)")
                
            } else {
                
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        
                        // convert data into an image
                        image = UIImage(data: imageData)!
                        
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                    else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code")
                }
            }
        }
        
        downloadPicTask.resume()
}

    
    func connectionFailed(){
        
        let alert:UIAlertController = UIAlertController(title: "Error", message: "Connection Failed", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //progressView?.isHidden = true
    }

}


    
    
    
    
    
    
    
    
    
    
    
    
 
