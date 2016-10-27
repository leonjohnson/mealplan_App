//
//  Calories&MacrosTableViewCell.swift
//  DailyMeals
//
//  Created by Jithu on 3/17/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {
    
    @IBOutlet var calorieNameLabel : UILabel!
    @IBOutlet var calorieQuantityLabel : UILabel!
    @IBOutlet var caloriePercentageLabel : UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
