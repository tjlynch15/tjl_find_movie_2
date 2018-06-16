//
//  SetLocationViewController.swift
//  Movie App
//
//  Created by terrence lynch on 9/2/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit

class SetLocationViewController: UIViewController, UITextFieldDelegate,
UINavigationControllerDelegate {

    
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var locationButton: UIButton!
    
    var passedZipCode: String?
    var useCurrentLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Handle the text field’s user input through delegate callbacks.
        zipCodeTextField.delegate = self
        
        
        // Enable the Save button only if the text field has a valid name.
        updateSaveButtonState()
        
        locationButton.layer.cornerRadius = 5
    }

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        
        useCurrentLocation = true
        print("useCurrentLocation: \(useCurrentLocation)")
        saveButton.isEnabled = true
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateSaveButtonState()
        useCurrentLocation = false
        navigationItem.title = textField.text
    }
    
    
    
    //MARK Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            
            print("setlocation prepare for seque return")
            return
        }
        
        passedZipCode = zipCodeTextField.text ?? ""
       
        print("setlocation prepare for seque passed")
    }
    
    

    
    //MARK Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = zipCodeTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
