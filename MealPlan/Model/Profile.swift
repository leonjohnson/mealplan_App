//
//  ProfileStep1.swift
//  DailyMeals
//
//  Created by Jithu on 4/6/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object {
    
    // Name of User
    dynamic var name                = ""        //      First Second
    // Gender of the User
    dynamic var gender              = -1        //      0 - male
    //                                                  1 - female
    // Daily Eating Cont
    dynamic var eattingTimes        = 1        //      1 - 6
    // Number of week Exercise
    dynamic var weekExerciseTimes   = 8        //      8 - 20
    // Age in years
    dynamic var age                 = ""        //      0 - 100
    
    // Active state of Job
    dynamic var workActive          = -1        //      0 - Sedentary
    //                                                  1 - Lightly active
    //                                                  2 - Moderately active
    //                                                  3 - Very active
    
    dynamic var goals               = ""          //    Golas will be a coma seprated string.
    
    // Weights or resistance training sessions doing in a week
    dynamic var traningSessions     = 0        // 0 - 7
    // Cardio sessions in each week            // 0 - 7
    dynamic var cardioSessions      = 0
    
    // Weight in Kg
    dynamic var weight              = -1.0         // 0 - 150
    // Height in Centimeters
    dynamic var height              = -1.0         // 0 - 300
    // Waist in Centimeters
    dynamic var waist               = -1.0         // 0 - 100
    
    // Type of Diatery
    dynamic var dietaryMethod       = -1         // 0 - Vegetarian
    //                                             1 - Vegan
    //                                             2 - Pescatarian
    //                                             3 - None of Above
    
    // Array of foods liked
    var likeFoodsList = List<Food>()
    // Array of foods disliked
    var disLikeFoodsList = List<Food>()
}
