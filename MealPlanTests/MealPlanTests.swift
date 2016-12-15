/*
 import XCTest
 @testable import MealPlan
 class ProfileTests: XCTestCase
 */

import XCTest
@testable import MealPlan
class MealPlanTests: XCTestCase {
    let mealPlans = MealPlanAlgorithm.createMeal()
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure { 
            // Put the code you want to measure the time of here.
        }
    }
    
    func testItMealPlanCreationForTheGivenDay(){
        for dayNumber in [6,7,8,14] {
            //given
            var status : Bool?
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let dateInFuture = (calendar as NSCalendar).date(byAdding: .day, value: dayNumber, to: today, options: [.matchFirst])
            let response = SetUpMealPlan.doesMealPlanExistForThisWeek()//withTodaysDate: Date()
            let mealPlanExistsForThisWeek = response.yayNay
            
            let weekInFuture = Week()
            weekInFuture.start_date = dateInFuture! //calRequirements
            let currentWeek = weekInFuture.currentWeek()
            let daysUntilExpiry = currentWeek?.daysUntilWeekExpires()
            guard currentWeek != nil else {
                print("Error at 1")
                return
            }
            
            
            //when
            if mealPlanExistsForThisWeek == false{
                //askForNewDetails()
                let calRequirements = SetUpMealPlan.calculateInitialCalorieAllowance() // generate new calorie requirements
                //SetUpMealPlan.createWeek(daysUntilCommencement: 0, calorieAllowance: calRequirements)
                //SetUpMealPlan.createWeek(daysUntilCommencement: 7, calorieAllowance: calRequirements)
                
                status = true
                XCTAssert(status! ,"This is day \(dayNumber). No meal plans exist for this week.")
                //takeUserToMealPlan(shouldShowExplainerScreen: true)
                
            } else {
                switch response.weeksAhead.count {
                case 0:
                    //askForNewDetails()
                    if dayNumber > 7{
                        status = true
                    } else {
                        status = false
                    }
                    
                    XCTAssert(status!,"This is day \(dayNumber). Meal plans exist for this week but not next. Will now askForNewDetails")
                    
                    //SetUpMealPlan.createWeek(daysUntilCommencement: daysUntilExpiry!, calorieAllowance: (currentWeek?.calorieAllowance)!)
                    //SetUpMealPlan.createWeek(daysUntilCommencement: (daysUntilExpiry! + 7), calorieAllowance: (currentWeek?.calorieAllowance)!)
                    //takeUserToMealPlan(shouldShowExplainerScreen: true)
                    
                    // run a new meal plan for next week and the week after
                case 1:
                    print("Case 1")
                    //askForNewDetails()
                    //var newCaloriesAllowance = 0
                    
                    guard currentWeek != nil else {
                        print("Error at 2")
                        return
                    }
                    var STANDARD_CALORIE_CUT : Bool?
                    if(Config.getBoolValue(Constants.STANDARD_CALORIE_CUT) == true){
                        //newCaloriesAllowance = SetUpMealPlan.cutCalories(fromWeek: currentWeek!, userfoundDiet: (currentWeek?.feedback?.easeOfFollowingDiet)!)
                        STANDARD_CALORIE_CUT = true
                        
                    } else {
                        //newCaloriesAllowance = SetUpMealPlan.initialCalorieCut(firstWeek: currentWeek!) // run initialCalorieCut
                        Config.setBoolValue(Constants.STANDARD_CALORIE_CUT,status: true)
                        STANDARD_CALORIE_CUT = false
                    }
                    
                    // run a new meal plan based on this for next week and the week after.
                    //SetUpMealPlan.createWeek(daysUntilCommencement: daysUntilExpiry!, calorieAllowance: newCaloriesAllowance)
                    //takeUserToMealPlan(shouldShowExplainerScreen: false)
                    
                    if dayNumber > 0 && dayNumber < 8{
                        status = true
                    } else {
                        status = false
                    }
                    XCTAssert(status!,"This is day \(dayNumber). Meal plans exist for this week AND next. No need to askForNewDetails. STANDARD_CALORIE_CUT? : \(STANDARD_CALORIE_CUT). Days unitil expiry: \(daysUntilExpiry). ")
                    
                case 2:
                    if dayNumber > 0 && dayNumber < 8{
                        status = true
                    } else {
                        status = false
                    }
                    XCTAssert(status!,"This is day \(dayNumber). Meal plans exist for this week AND next AND one thereafter. Days unitil expiry: \(daysUntilExpiry). ")
                return //we're good so return to your meal plan
                default:
                    // this could be because the user is between the 8th day and 12th day of a meal plan.
                    return
                }
            }

        }
    }
    
    func testMealsPlanSize(){
        //A meal plan is created that contains the number of meals
        //recorded as the users preference, which must be between 2 and 8
        var status = true
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
                break
            }
            var mealsName = [String]()
            for meal in mealPlan.meals {
                if(mealsName.contains(meal.name)){
                    status = false
                    break
                }
                mealsName.append(meal.name)
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
                break
            }
            for meal in mealPlan.meals {
                if(!status){
                    break
                }

                for fooditem in meal.foodItems {
                    if(foodsDisLiked.foods.contains(fooditem.food!)){
                        status = false
                        break
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
