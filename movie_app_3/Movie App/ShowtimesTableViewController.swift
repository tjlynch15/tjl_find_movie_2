//
//  ShowtimesTableViewController.swift
//  Movie App
//
//  Created by terrence lynch on 8/15/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit


// Class ShowtimesTableViewController gets ticket URI andconcatenates time. The concatenated URI is then used to link to the Fandago webpage to purchase tickets

class ShowtimesTableViewController: UITableViewController, ShowtimeCellDelegate {

    
    var passedShowtimes: [Dictionary<String, Any>]?
    
    var showTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.tableView.backgroundColor = UIColor.lightGray
        
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
      
        return passedShowtimes!.count
       
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ShowtimeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShowtimeTableViewCell  else {fatalError("The dequeued cell is not an instance of ShowtimeTableViewCell.")
        }
        
        // Fetches the appropriate data for the data source layout.
        
        
        var name: String
        var dateTime: String
        var ticketURI: String
        
        let showtime = passedShowtimes?[indexPath.row]
        
        dateTime = showtime?["dateTime"]! as! String

        let convertedDate = convertDate(date: dateTime)
        
        print("convertedDate: \(convertedDate)")
        
        showTime = getTime(date: dateTime)
        print(showTime)
        
        let convertedTime = convertTime(time: showTime)
        
        let day = getDay(date: dateTime)
        
        if showtime?["ticketURI"] != nil  {
            
            ticketURI = showtime?["ticketURI"]! as! String
            
            let newTicketURI = "\(ticketURI)" + "+" + "\(showTime)"
            
            print(newTicketURI)
        }
        
        let theater = showtime?["theatre"] as! [String: Any]
        
        name = theater["name"]! as! String
        
        print(name)
        
        cell.theaterNameLabel.text = name
        cell.dateTimeLabel.text = convertedDate
        cell.timeLabel.text = convertedTime
        
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        cell.ticketButton.tag = indexPath.row
        cell.ticketButton.layer.cornerRadius = 10
        cell.ticketButton.layer.borderWidth = 1
        cell.ticketButton.layer.borderColor = UIColor.black.cgColor
        
        if (compareTimes(timeString: showTime, dayString: day)) {
            
            cell.ticketButton.backgroundColor = UIColor.blue
            cell.ticketButton.isEnabled = true
        }
        else {
            cell.ticketButton.isEnabled = false
            cell.ticketButton.backgroundColor = UIColor.clear
            
        }
            
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    
    func didPressButton(_ tag: Int) {
        
        print("I have pressed a button with a tag: \(tag)")
        
        var ticketURI = ""
        var newTicketURI = ""
        
        let showtime = passedShowtimes?[tag]
        
        let dateTime = showtime?["dateTime"]! as! String
        
        print(dateTime)
        
        showTime = getTime(date: dateTime)
        print(showTime)
        
        
        if showtime?["ticketURI"] != nil  {
            
            ticketURI = showtime?["ticketURI"]! as! String
            
            print(ticketURI)
            
            newTicketURI = "\(ticketURI)" + "+" + "\(showTime)"
            
            print(newTicketURI)
            
        }
        
        SharedNetworking.sharedInstance.showNetworkIndicator()
        
        let url = URL(string: newTicketURI)!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
        SharedNetworking.sharedInstance.hideNetworkIndicator()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func convertDate (date: String) -> String {
        
        let dateArray = date.components(separatedBy: "T")
        
        let dateString = dateArray[0]
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = NSLocale.current
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let someDate = dateFormatter.date(from: dateString)
        
        dateFormatter.dateStyle = .medium
        
        let newDate = dateFormatter.string(from: someDate!)
        
        
        return newDate
    }
    
    
    
    func getTime (date: String) -> String{
        
        let dateArray = date.components(separatedBy: "T")
        
        let timeString = dateArray[1]
        
        return timeString
 
    }
    
    func getDay (date: String) -> String{
        
        let dateTimeArray = date.components(separatedBy: "T")
        
        let date = dateTimeArray[0]
        
        let dateArray = date.components(separatedBy: "-")
        
        print("day: \(dateArray[2])")
        
        return dateArray[2]
        
    }
    
    
    
    
    
    func convertTime (time: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = NSLocale.current
        
        dateFormatter.dateFormat = "HH-mm"
        
        let someTime = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "h:mm a"
        
        let newTime = dateFormatter.string(from: someTime!)
        
        return newTime
    }
    
    
    func compareTimes (timeString: String, dayString: String) -> Bool {
        
        //let current_date = NSDate()
        
        print("sttvc timeString: \(timeString)")
        print("sttvc dateString: \(dayString)")
        
        let date = Date()
        let calendar = Calendar.current
        
        let current_day = calendar.component(.day, from: date)
        let current_hour = calendar.component(.hour, from: date)
        let current_minutes = calendar.component(.minute, from: date)
        print("current day: \(current_day)")
        print("current hour: \(current_hour)")
        print("current minutes \(current_minutes)")
        
        let timeArray = timeString.components(separatedBy: ":")
        
        let movie_day = Int(dayString)
        let movie_hour = Int(timeArray[0])
        let movie_minutes = Int(timeArray[1])
        
        print("movie day: \(movie_day!)")
        print("movie hour: \(movie_hour!)")
        print("movie minutes: \(movie_minutes!)")
        
        
        if ((movie_day! > current_day) || (movie_day! == current_day && movie_hour! > current_hour) || (movie_day! == current_day && movie_hour! == current_hour && movie_minutes! > current_minutes)) {
            
            print("true")
            return true
        }
            
        else {
            print("false")
            return false
        }
    }
    
    
}















