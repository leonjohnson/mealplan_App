//
//  mealsPlanCellTableViewCell.swift
//  DailyMeals
//
//  Created by Jithu on 3/16/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class mealsPlanCellTableViewCell: UITableViewCell {
    
    @IBOutlet var foodNameLabel : UILabel!
    @IBOutlet var foodQuantityLabel : UILabel!
    @IBOutlet var foodCaloryLabel : UILabel!
    @IBOutlet var mealArrowImage : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
