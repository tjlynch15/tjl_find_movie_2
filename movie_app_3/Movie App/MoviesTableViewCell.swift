//
//  MoviesTableViewCell.swift
//  Movie App
//
//  Created by terrence lynch on 8/15/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit


class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
