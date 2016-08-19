//
//  Week.swift
//  DailyMeals
//
//  Created by Mzalih on 20/04/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyMeal: Object {
    
    //  WeekId is the id of the week for the date
    // It vary from 0 to the maximum weeks selected
    dynamic var weekId = 0
    //  Array of daily meals for each day
    
    // It holds 7 Daily meals
    let melsPerDay = List<DailyMeal>()
    
    dynamic var feedBackForTheWeek:FeedBack?
}
