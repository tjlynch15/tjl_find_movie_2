//
//  NowPlayingTableViewCell.swift
//  Movie App
//
//  Created by terrence lynch on 8/10/17.
//  Copyright © 2017 terrence lynch. All rights reserved.
//

import UIKit

class NowPlayingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
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
