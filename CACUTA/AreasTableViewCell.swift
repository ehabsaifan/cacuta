//
//  AreaTableViewCell.swift
//  UTA//
//  Created by Ehab Saifan on 6/10/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class AreasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var areaName: UILabel!
    @IBOutlet weak var areaTitle: UILabel!
    @IBOutlet weak var areaDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
