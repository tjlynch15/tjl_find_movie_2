//
//  PopoverViewController.swift
//  Movie App
//
//  Created by terrence lynch on 9/7/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var myDatePicker: UIDatePicker!    
    @IBOutlet weak var okButton: UIButton!
    
    var selectedDate = ""
    var passedDate: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        components.day = 0
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        components.day = 7
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        self.myDatePicker.minimumDate = minDate as Date
        self.myDatePicker.maximumDate = maxDate as Date
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Navigation
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === okButton else {
            
            print("setdate prepare for seque return")
            return
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(from: myDatePicker.date)
        print("selected Date: \(selectedDate)")
        
        passedDate = selectedDate
        
        dismiss(animated: true, completion: nil)
        
        print("setdate prepare for seque passed")
    }
    
     
    @IBAction func cancelDatePicker(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
     
     
 
}











