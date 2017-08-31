//
//  NullTableViewCell.swift
//  CACUTA
//
//  Created by Ehab Saifan on 8/30/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class NullTableViewCell: UITableViewCell {

    @IBOutlet weak var addCoursesBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addCoursesBtn.makeCircularEdges()
    }

}
