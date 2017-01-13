//
//  miniTableViewCell.swift
//  MealPlan
//
//  Created by Leon Johnson on 15/11/2016.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class miniTableViewCell: UITableViewCell {

    var incomingCellDelegate: IncomingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.accessoryType = .checkmark
        //self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        //self.accessoryType = .none
    }
    
    
    
    
    
    
}
