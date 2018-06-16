//
//  ShowtimeTableViewCell.swift
//  Movie App
//
//  Created by terrence lynch on 8/15/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit



protocol ShowtimeCellDelegate: class {
    func didPressButton(_ tag: Int)
}


class ShowtimeTableViewCell: UITableViewCell {

    @IBOutlet weak var theaterNameLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var ticketButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    
    weak var cellDelegate: ShowtimesTableViewController?
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
       cellDelegate?.didPressButton(sender.tag)
        
    }
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
