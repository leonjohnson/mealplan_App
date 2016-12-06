//
//  MealPlanTests.swift
//  MealPlanTests
//
//  Created by toobler on 06/12/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import XCTest
@testable import MealPlan
class MealPlanTests: XCTestCase {
    let mealPlans = MealPlanAlgorithm.createMeal();
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
    func testMealsPlanSize(){
        //A meal plan is created that contains the number of meals
        //recorded as the users preference, which must be between 2 and 8
        var status = true;
        for mealPlan in mealPlans {
            if(!(mealPlan.meals.count >= 2 && mealPlan.meals.count <= 8)){
                status = false;
                break;
            }
        }
        XCTAssert( status ,"which must be between 2 and 8")
    }
    func testMealsPlanfoodSize(){
        var status = true;
        for mealPlan in mealPlans {
            //Each meal contains at least one food
            for meal in mealPlan.meals {
                if(!(meal.foodItems.count>0)){
                 status = false;
                     break;
                }
            }
        }
        XCTAssert(status,"Each meal contains at least one food")
    }
    func testMealsPlanRepetation(){
        //No two meals within the same day, have the same name
        var status = true;
        for mealPlan in mealPlans {
            if(!status){
                break;
            }
            var mealsName = [String]()
            for meal in mealPlan.meals {
                if(mealsName.contains(meal.name)){
                    status = false
                    break;
                }
                mealsName.append(meal.name);
            }
        }
         XCTAssert(status,"No two meals within the same day, have the same name")
    }
    func testMealsPlanfoodsareNonInDisliked(){
        //The foods selected must not be in the users disliked list
        let foodsDisLiked = DataHandler.getDisLikedFoods()
        var status = true;
        for mealPlan in mealPlans {

            if(!status){
                break;
            }
            for meal in mealPlan.meals {
                if(!status){
                    break;
                }

                for food in meal.foodItems {
                    if(foodsDisLiked.foods.contains(food.food!)){
                        status = false;
                        break;
                    }
                }
            }
        }
         XCTAssert(status,"the foods selected must not be in the users disliked list")
    }
    func testMealsPlan(){

        var status = true

        for mealPlan in mealPlans {

            if(!status){
                break;
            }

            // each meal’s carbohydrates, proteins, and fats should be equally divided +-15%
            for meal in mealPlan.meals {

                var carbohydrate = 0.0;
                var protein = 0.0;
                var fats = 0.0;

                // Calculate total calories ina Meals
                for food in meal.foodItems {
                    carbohydrate = carbohydrate + (food.food?.carbohydrates)!
                    protein = protein + (food.food?.proteins)!
                    fats = fats + (food.food?.fats)!
                }

                // Get the Total of each Calories
                let total = carbohydrate + protein + fats;

                // Get the percentage of each Calories
                let carbohydratePercentage  = ( carbohydrate / total ) * 100
                let proteinPercentage  = ( protein / total ) * 100
                let fatsPercentage  = ( fats / total ) * 100

                // Get the avrerage of each Calories
                let avg = 100.0/3.0;

                if(!(avg - carbohydratePercentage < 15 &&  avg - carbohydratePercentage > -15)){
                    status = false;
                    break;
                }
                if(!(avg - proteinPercentage < 15 &&  avg - proteinPercentage > -15)){
                    status = false;
                    break;
                }
                if(!(avg - fatsPercentage < 15 &&  avg - fatsPercentage > -15)){
                    status = false;
                    break;
                }

            }
        }
        XCTAssert( status,
                   "Each meal’s carbohydrates,proteins,fats should be equally divided +-15%")
    }

}
