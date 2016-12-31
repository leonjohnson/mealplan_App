//
//  BotDelegate.swift
//  MealPlan
//
//  Created by Leon Johnson on 24/11/2016.
//  Copyright © 2016 Meals. All rights reserved.
//

import Foundation

@objc protocol BotDelegate {
    @objc optional func originalrowSelected(labelValue: String, withQuestion: String, index:IndexPath, addOrDelete:UITableViewCellAccessoryType)
    @objc optional func buttonTapped(button: UIButton)
}


