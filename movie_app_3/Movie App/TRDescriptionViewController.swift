//
//  TRDescriptionViewController.swift
//  Movie App
//
//  Created by terrence lynch on 8/12/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit

// Controller for the movie description view when a movie in the TopRatedTableview is selected

class TRDescriptionViewController: UIViewController {

    var passedTitle: String?
    var passedMovieId: String?
    var passedPosterPath: String?
    var passedOverview: String?
   
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieOverview: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print("TR Description ViewDidLoad")
        print(passedTitle as Any)
        print(passedPosterPath as Any)
        print(passedOverview as Any)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.movieTitle.text = passedTitle
        self.movieOverview.text = passedOverview
        downloadImage()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // Attribution: - https://stackoverflow.com/questions/39813497/swift-3-display-image-from-url
    
    func downloadImage() {
        
        var image = UIImage()
        
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w300" + passedPosterPath!)
        print("poster url: \(String(describing: posterURL))")
        
        // Create a session object with the default configuration.
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object.
        let downloadPicTask = session.dataTask(with: posterURL!) { (data, response, error) in
            // The download has finished.
            if let e = error {
                
                self.connectionFailed()
                
                print("Error downloading picture: \(e)")
            }
            else {
                
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        
                        // Convert the Data into an image.
                        image = UIImage(data: imageData)!
                        
                        DispatchQueue.main.async {
                            self.posterImageView.image = image
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
