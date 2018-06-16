//
//  TopRatedTableViewCell.swift
//  Movie App
//
//  Created by terrence lynch on 8/11/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit

class TopRatedTableViewCell: UITableViewCell {

    @IBOutlet weak var topRatedTitle: UILabel!
    @IBOutlet weak var topRatedReleaseDate: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
