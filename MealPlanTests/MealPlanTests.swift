/*
 import XCTest
 @testable import MealPlan
 class ProfileTests: XCTestCase
 */

import XCTest
@testable import MealPlan
class MealPlanTests: XCTestCase {
    var mealPlans : [DailyMealPlan] = []
    let thisWeek = Week().currentWeek()
    var thisWeeksProtein : Double = 0
    var thisWeeksCarbs : Double = 0
    var thisWeeksFats : Double = 0
    
    
    /*
     Create test for - doesMealPlanExistForThisWeek
    */
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let thisWeek = Week().currentWeek()
        let macros = thisWeek?.macroAllocation
        thisWeeksProtein = (macros?[0].value)!
        thisWeeksCarbs = (macros?[1].value)!
        thisWeeksFats = (macros?[2].value)!
        mealPlans = MealPlanAlgorithm.createMealPlans(self.thisWeek!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure { 
            // Put the code you want to measure the time of here.
            _ = MealPlanAlgorithm.createMealPlans(self.thisWeek!)
        }
    }
    
    func testItMealPlanCreationForTheGivenDay(){
        for dayNumber in [6,7,8,14] {
            //given
            var status : Bool?
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let dateInFuture = (calendar as NSCalendar).date(byAdding: .day, value: dayNumber, to: (thisWeek?.start_date)!, options: [.matchFirst])
            let response = SetUpMealPlan.doesMealPlanExistForThisWeek(withTodaysDate: dateInFuture!)
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
                    
                    if dayNumber > 0 && dayNumber <= 7{
                        status = true
                    } else {
                        status = false
                    }
                    XCTAssert(status!,"This is day \(dayNumber). Meal plans exist for this week AND next. No need to askForNewDetails. STANDARD_CALORIE_CUT? : \(STANDARD_CALORIE_CUT). Days unitil expiry: \(daysUntilExpiry). ")
                    
                case 2:
                    if dayNumber > 7 && dayNumber <= 14{
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
        XCTAssert( status ,"the meals number between 2 and 8")
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
    
    func testMealsPlanRepetition(){
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
        var status = true
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

        var status : Bool?
        var totalProtein = 0.0
        var totalCarbohydrates = 0.0
        var totalFats = 0.0
        var totalCalories = 0.0

        for mealPlan in mealPlans {
            totalProtein = totalProtein + mealPlan.totalProteins()
            totalCarbohydrates = totalCarbohydrates + mealPlan.totalCarbohydrates()
            totalFats = totalFats + mealPlan.totalFats()
            totalCalories = mealPlan.totalCalories()
        }
        
        print("total carbs: \(totalCarbohydrates), total protein: \(totalProtein), total fats: \(totalFats)")
        totalProtein = totalProtein/Double(mealPlans.count)
        totalCarbohydrates = totalCarbohydrates/Double(mealPlans.count)
        totalFats = totalFats/Double(mealPlans.count)
        
        if totalCarbohydrates >= (thisWeeksCarbs - 7.0) && totalCarbohydrates <= (thisWeeksCarbs + 7.0) &&
            totalProtein >= (thisWeeksProtein - 7.0) && totalProtein <= (thisWeeksProtein + 7.0) &&
            totalFats >= (thisWeeksFats - 3.0) && totalFats <= (thisWeeksFats + 3.0){
            status = true
        } else {
            status = false
        }
            
        XCTAssert(status!,
                   "total carbs: \(totalCarbohydrates). total proteins: \(totalProtein). total fats: \(totalFats)")
    }

}
