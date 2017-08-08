//
//  FavoriteCourseTableViewCell.swift
//  CACUTA
//  Created by Ehab Saifan on 6/17/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class FavoriteCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseStatus: UILabel!
    @IBOutlet weak var courseUnitss: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
