//
//  NowPlayingTableViewController.swift
//  Movie App
//
//  Created by terrence lynch on 8/10/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit

class NowPlayingTableViewController: UITableViewController {

    
    /// The array of dictionaries that will hold all moview
    /// data returned from the network request
    var issues:[[String: AnyObject]]?
    
    var dictionaryArray = [Dictionary<String, Any>]()
    
    let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=4cccd6917c9ed5fd7472f9b5d2d95df6&language=en-US&page=1"
    
    var aboutView: UIView?
    
    @IBOutlet weak var aboutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        showDefaults()
        
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func showDefaults() {
        
        let defaults = UserDefaults.standard
        let developer_name = defaults.string(forKey: "developer_name")
        let initial_launch = defaults.string(forKey: "initial_launch")
        let selected_radius = defaults.string(forKey: "selected_radius")
        
        print("Name: \(developer_name ?? "defaults error")")
        print("Initial Launch: \(initial_launch ?? "defaults error")")
        print("Radius: \(selected_radius ?? "defaults error")")
        print()
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
        let cellIdentifier = "NowPlayingTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NowPlayingTableViewCell  else {fatalError("The dequeued cell is not an instance of NowPlayingTableViewCell.")
        }
        
        // Fetches the appropriate issue for the data source layout.
        let issue = dictionaryArray[indexPath.row]
       
        print(issue["title"]!)
        cell.movieTitle.text = issue["title"] as? String
        cell.releaseDate.text = "Release Date: " + "\(issue["release_date"] as! String)"
        
        downloadImage(posterPath: issue["poster_path"] as! String, index: indexPath.row) { (thumbImage) in
            cell.movieImage.image = thumbImage
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        
        guard let npdvc = segue.destination as? NPDescriptionViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedCell = sender as? NowPlayingTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        
        npdvc.passedTitle = dictionaryArray[indexPath.row]["title"]! as? String
        npdvc.passedMovieId = dictionaryArray[indexPath.row]["movieId"]! as? String
        npdvc.passedPosterPath = dictionaryArray[indexPath.row]["poster_path"]! as? String
        npdvc.passedOverview = dictionaryArray[indexPath.row]["overview"]! as? String
        
    }
    
    
    
    
    func createDictionary(issues: [[String: AnyObject]]) {
        
        let numIssues = issues.count
        print("numIssues: \(numIssues)")
        
        print()
        
        
        var issueDictionary: [String:Any] = [:]
        
        dictionaryArray = [Dictionary<String, Any>]()
        
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
                
                issueDictionary = ["title":title, "movieId":movieId, "release_date":convertedReleaseDate, "poster_path":poster_path, "overview":overview]
                
                dictionaryArray.append(issueDictionary)
                
            }
        }
        print("NowPlayingTableViewController")
        print(dictionaryArray)
        print("dictionaryArray count: \(dictionaryArray.count)")
    }
    

    
    // Creates about view as dropdown
    
    func showCustomView() {
        
        //Create About Subview
        aboutView = UIView()
        aboutView?.frame =  CGRect(x: 0, y: -1000, width: self.view.frame.width, height: self.view.frame.height)
        
        //aboutView.contentMode = UIViewContentMode.scaleAspectFit
        aboutView?.backgroundColor = .lightGray
        view.addSubview(aboutView!)
        
        let aboutTextView: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aboutTextView.backgroundColor = .lightGray
        
        aboutView?.addSubview(aboutTextView)
    
        let webV:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100))
        
        
        if let url = Bundle.main.url(forResource: "About",
                                     withExtension: "html") {
            if let htmlData = try? Data(contentsOf: url) {
                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                webV.load(htmlData, mimeType: "text/html",
                             textEncodingName: "UTF-8", baseURL: baseURL)
            }
        }
        
        webV.delegate = self as? UIWebViewDelegate;
        aboutTextView.addSubview(webV)
    
        
        
        let button = UIButton(frame: CGRect(x: self.view.center.x - 30, y: self.view.frame.height - 150, width: 60, height: 30))
        //button.center = (aboutView?.center)!
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(NowPlayingTableViewController.closeButtonTapped), for: .touchUpInside)
        webV.addSubview(button)
        
        
        UIView.animate(withDuration: 1.0, delay: 0.1, options: [.curveEaseIn], animations: {
            
            self.aboutView?.center = self.view.center
            
        }, completion: nil)
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
    
        print("About Button Tapped")
        self.showCustomView()
        aboutButton.isEnabled = false
    }
    
    
    @objc func closeButtonTapped() {
        
        print("Close Button Tapped")
        UIView.animate(withDuration: 1.0,delay: 0.1, options: [.curveEaseOut], animations: {
            self.aboutView?.frame = CGRect(x: 0, y: -1000, width: 375, height: 667)
        }, completion: nil)
        
        aboutButton.isEnabled = true
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
        
    }
    
    
}








