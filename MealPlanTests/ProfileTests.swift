//
//  ProfileTests.swift
//  MealPlan
//
//  Created by Arun P S on 12/8/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import XCTest
@testable import MealPlan
class ProfileTests: XCTestCase {
    

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testProfileTDEEComparsion() {
        
        
        let profileInputObject: NSMutableDictionary = [
            "EntryDate" : 1 as Int,
            "FirstName" : "Jack" as String,
            "email" : "" as String,
            "Gender" : "male" as String,
            "Height" : 180.3 as Double,
            "Weight" : 98.9 as Double,
            "Age" : 23 as Int,
            "Occupation" : 1 as Int,
            "ExerciseCount" : 3 as Int,
            "ExerciseIntensity" : 2 as Int,
            "Meals" : 4 as Int,
            "Goal" : 1 as Int,
            "REE" : 2172 as Int,
            "TDEE" : 2827 as Float,
            "AdjustedTDEE" : 2403 as Float,
            "Protein" : 247 as Int,
            "Fat" : 67 as Int,
            "Carbohydrate" : 203 as Int,
            "activityLevelAtWork" : "Very active" as String,
        ]
        
         let mealsPlanProfileArray=NSMutableArray()
         mealsPlanProfileArray.add(profileInputObject)
        
        for parsedObject in mealsPlanProfileArray as NSMutableArray
        {
            
            //CREATING USER OBJECT
            let  userObject = User()
            userObject.name = (parsedObject as! NSMutableDictionary).value(forKey: "FirstName") as! String
            userObject.email = (parsedObject as! NSMutableDictionary).value(forKey: "email") as! String
            userObject.gender = (parsedObject as! NSMutableDictionary).value(forKey: "Gender") as! String
            
            //CREATING BIGRAPHICAL OBJECT
            let  biographicalObject = Biographical()
            biographicalObject.numberOfDailyMeals = (parsedObject as! NSMutableDictionary).value(forKey: "Meals")as! Int
            biographicalObject.heightUnit = "cm"
            biographicalObject.weightUnit = "kg"
            biographicalObject.numberOfCardioSessionsEachWeek = (parsedObject as! NSMutableDictionary).value(forKey: "ExerciseCount")as! Int
            biographicalObject.numberOfResistanceSessionsEachWeek = (parsedObject as! NSMutableDictionary).value(forKey: "ExerciseIntensity")as! Int
            biographicalObject.heightMeasurement = (parsedObject as! NSMutableDictionary).value(forKey: "Height")as! Double
            biographicalObject.weightMeasurement = (parsedObject as! NSMutableDictionary).value(forKey: "Weight")as! Double
            biographicalObject.activityLevelAtWork = (parsedObject as! NSMutableDictionary).value(forKey: "activityLevelAtWork")as? String
            
            
            let mealPlansTDEE = Float(SetUpMealPlan.calculateTDEE(bio: biographicalObject, user: userObject))
            
            print(mealPlansTDEE)
            
            let AdjustedTDEE = (parsedObject as! NSMutableDictionary).value(forKey: "AdjustedTDEE") as! Float
            let TDEE =  (parsedObject as! NSMutableDictionary).value(forKey: "TDEE")  as! Float
            
            XCTAssertEqualWithAccuracy(mealPlansTDEE, TDEE, accuracy: 10)
            //XCTAssertNotEqualWithAccuracy(TDEE, AdjustedTDEE, mealPlansTDEE, "failuer")
           
        }
            
           
  }
    
}
