//
//  TheatersTableViewController.swift
//  Movie App
//
//  Created by terrence lynch on 8/14/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//


import UIKit
import CoreLocation


// Class TheatersTableViewController uses users current location to display a tableview of movies playing within a five mile radius of user

class NearMeTableViewController: UITableViewController {
    
    let dateFormatter = DateFormatter()
    var aboutView: UIView?
    var movies = [Movie]()
    var urlString = ""
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var useCurrentLoc = true
    var zipCode = ""
    var convertedDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        print("VIEW DID LOAD")
        
        self.tableView.backgroundColor = UIColor.lightGray
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        // Check permission status
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        // Handle all different levels of permissions
        switch authStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
            
            return
            
        case .denied, .restricted:
            presentLocationServicesAlert("Location Services",
                                         message: "Please enable location services for this app in Settings.")
            return
            
        case .authorizedAlways:
            locationManager.requestLocation()
            
            if locationManager.location != nil {
                print(locationManager.location as Any)
                currentLocation = locationManager.location!
            }
            
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            
            if locationManager.location != nil {
                print("authorizedWhenInUse  \(locationManager.location as Any)")
                currentLocation = locationManager.location!
            }
        }
        
        self.refreshControl?.addTarget(self, action: #selector(NearMeTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    
    func getMovies()  {
        
        print("GetMovies!!!!!!")
        
        var myLongitude = currentLocation!.coordinate.longitude
        var myLatitude = currentLocation!.coordinate.latitude
        
        if currentLocation == nil {
            myLongitude = 0
            myLatitude = 0
        }
        
        print("my long: \(myLongitude)")
        print("my lat: \(myLatitude)")
        
        
        if convertedDate == "" {
            let currentDate = NSDate()
            print(currentDate)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            convertedDate = dateFormatter.string(from: currentDate as Date)
            print("converted date: \(convertedDate)")
        }
        
        let defaults = UserDefaults.standard
        let selected_radius = defaults.string(forKey: "selected_radius")!
        print("selected radius: \(selected_radius)")
        
        if zipCode == "" {
            urlString = "https://data.tmsapi.com/v1.1/movies/showings?startDate=\(convertedDate)&lat=\(myLatitude)&lng=\(myLongitude)&radius=\(selected_radius)&api_key=jbxsdaywdw3vfawhcjtyangk"
        }
            
        else {
            urlString = "https://data.tmsapi.com/v1.1/movies/showings?startDate=\(convertedDate)&zip=\(zipCode)&radius=\(selected_radius)&api_key=jbxsdaywdw3vfawhcjtyangk"
        }
        
        print(urlString)
        
        SharedNetworking.sharedInstance.showNetworkIndicator()
        
        SharedNetworking.sharedInstance.getIssues2(url: urlString) { (issues) in
            
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
        if (self.refreshControl?.isRefreshing)! {
            self.refreshControl?.endRefreshing()
            print("end refreshing")
        }
    }
    

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        print("refresh!!")
        
        currentLocation = nil
        
        print(currentLocation ?? "nil")
        
        locationManager.requestLocation()
        
//        self.refreshControl?.endRefreshing()
//        print("end refreshing")
    }
    
    
    /// Show an alert with information about the location services status
    func presentLocationServicesAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let affirmativeAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) -> Void in
            // Launch Settings.app directly to the app
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            
        }
        
        alert.addAction(affirmativeAction)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MoviesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MoviesTableViewCell  else {fatalError("The dequeued cell is not an instance of MoviesTableViewCell.")
        }
        
        // Fetches the appropriate issue for the data source layout.
        let movie = movies[indexPath.row]
        
        print(movie.title)
        
        cell.movieLabel.text = movie.title
        
//        downloadImage(posterPath: movie.imageURL, index: indexPath.row) { (thumbImage) in
//            cell.movieImage.image = thumbImage
//        }
        
        return cell
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "setLocationSegue":
            
            print("setLocationSegue")
            
        case "showtimesSegue":
            
            guard let showtimesvc = segue.destination as? ShowtimesTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? MoviesTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            showtimesvc.passedShowtimes = movies[indexPath.row].showtimes
            
        case "popoverSegue":
            
            print("setDateSegue")
        
        
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
    }
    
    
    @IBAction func unwindToTheaterList1(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? SetLocationViewController {
            
            if sourceViewController.useCurrentLocation == true {
                useCurrentLoc = true
                zipCode = ""
                locationManager.requestLocation()
            }
            else {
                useCurrentLoc = false
                zipCode = sourceViewController.passedZipCode!
                print("zip code: \(zipCode)")
                getMovies()
            }
        }
    }
  
    
    @IBAction func unwindToTheaterList2(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? PopoverViewController {
            let date = sourceViewController.passedDate!
            print("date: \(date)")
            convertedDate = date
            locationManager.requestLocation()
        }
    }
    
    
    func createDictionary(issues: [[String: Any]]) {
        
        movies = [Movie]()
        
        let numIssues = issues.count
        print("numIssues: \(numIssues)")
        print()
        
        var title = ""
        var preferredImage: Dictionary<String, Any>
        var imageURL = ""
        var formattedImageURL = ""
        var showtimes: [Dictionary<String, Any>]
        
        for index in 0..<numIssues {
            
            // access all objects in array
            
            if (issues[index]["title"] != nil) {
                
                title = (issues[index]["title"] as! String)
                preferredImage = (issues[index]["preferredImage"] as! Dictionary<String, Any>)
                imageURL = (preferredImage["uri"] as! String)
                formattedImageURL = "https://developer.tmsimg.com/\(imageURL)?api_key=jbxsdaywdw3vfawhcjtyangk"
                
                showtimes = issues[index]["showtimes"] as! [Dictionary<String, Any>]
                
                print("title: \(title)")
                print("imageURL: \(imageURL)")
                print("formattedImageURL: \(formattedImageURL)")
                print("showtimes: \(showtimes)")
                
                guard let movie = Movie(title: title, imageURL: formattedImageURL, showtimes: showtimes)
                    else {fatalError("Unable to instantiate movie")
                }
                
                movies.append(movie)
            }
        }
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
        
        let posterURL = URL(string: posterPath)
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


extension NearMeTableViewController : CLLocationManagerDelegate {
    
    @objc(locationManager:didChangeAuthorizationStatus:) func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locationManager.requestLocation()
            
            print("dCAS current location: \(String(describing: currentLocation))")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            print(locations)
            
            print("dUL location:: \(location)")
            currentLocation = location
        
            print("currentLocation:: \(String(describing: currentLocation))")
            getMovies()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (location not enabled)")
    }
    
    
}


// https://data.tmsapi.com/v1.1/movies/assets/p13446354_p_v5_ad.jpg?api_key=jbxsdaywdw3vfawhcjtyangk

//var movieData = '<div class="tile"><img src="http://developer.tmsimg.com/' + movie.preferredImage.uri + '?api_key='+apikey+'"><br/>';






