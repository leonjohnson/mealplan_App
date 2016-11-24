//
//  OutgoingCellDelegate.swift
//  MealPlan
//
//  Created by Leon Johnson on 24/11/2016.
//  Copyright © 2016 Meals. All rights reserved.
//

import Foundation

protocol OutgoingCellDelegate {
    func rowSelected(labelValue: String, withQuestion: String)
}
