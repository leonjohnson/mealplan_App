//
//  PayemtControllerImageTableViewCell.swift
//  DailyMeals
//
//  Created by Jithu on 4/11/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class PayemtControllerImageTableViewCell: UITableViewCell {
    
    @IBOutlet var imageHeaderLabel : UILabel!
    @IBOutlet var imageCell : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
