import UIKit
import RealmSwift

class DataStructure : NSObject{
    
    
    static func loadDatabaseWithData(){
        
        if (Config.getBoolValue("isCreated")){
            return
        }
        
        DietSuitability.addRowData();
        FoodType.addFoodTypes()
        
        
        Connect.fetchInitialFoods(nil) { (foods, json, status) -> Void in
            
            if(status == false){
                
                // @todo show an alert that we need a alert here
                print("STATUS : \(status)")
                return;
            }
            
            //Load nutritional information for these foods.
            for  food in foods{
                DataHandler.createFood(food);
            }

            //Add the food pairings
            addFoodPairingsToDatabase(foods,json: json)
            
            //createMeal();
            Config.setBoolValue("isCreated", status: true);
            
        }
        
        
    }
     //TO DO COMMENDTS
    
    
    
    /**
     This function takes an array of foods and their attributes and inputs any foods labelled as 'oftenEatenWith'
     or 'alwaysEatenWithOneOf' into the database.
     
     
     - parameter foods: A List of Foods in the database that don't have 'oftenEatenWith' or 'alwaysEatenWithOneOf' yet.
     - parameter json: NSArray of foods and their attributes including.
     
     
     */
    static func addFoodPairingsToDatabase (foods:[Food], json:NSArray)
    {
        
        let realm = try! Realm()
        for (index, food) in foods.enumerate() {
            
            let foodInJsonArray : NSDictionary = (json.objectAtIndex(index) as? NSDictionary)!
            let oftenEatenWith : NSArray = foodInJsonArray.objectForKey("oftenEatenWith") as! NSArray
            let alwaysEatenWithOneOf : NSArray = foodInJsonArray.objectForKey("alwaysEatenWithOneOf") as! NSArray
            
            let foodToEdit = realm.objects(Food).filter("name == %@", food.name)
            
            let realm = try! Realm()
            try! realm.write {
                
                if oftenEatenWith.count > 0 {
                    //for each in
                    let foodPredicate = NSPredicate(format: "name IN %@", oftenEatenWith)
                    let oew = realm.objects(Food).filter(foodPredicate)
                    foodToEdit.first!.setValue(List(oew), forKey: "oftenEatenWith")
                }
                
                if alwaysEatenWithOneOf.count > 0 {
                    let foodPredicate2 = NSPredicate(format: "name IN %@", alwaysEatenWithOneOf)
                    let aew = realm.objects(Food).filter(foodPredicate2)
                    foodToEdit.first!.setValue(List(aew), forKey: "alwaysEatenWithOneOf")
                }
                
            }
        }
        
    }
    
    
    //RULES:
    //Add water and randomly add a low calorie drink for last meal
    // At least two meals, excluding breakfast, should include some vegetables or fruit for fibre if dietary fibre is less than expected.
    
    static func  createMeal() -> [DailyMealPlan]{
        //let week = Week();
        var listOfMeals : [DailyMealPlan] = []
        for i in 1...7 {
        let dailyMeal = DailyMealPlan()
        dailyMeal.meals.append(createMeal(1, countValue: i))
        dailyMeal.meals.append(createMeal(2, countValue: i))
        dailyMeal.meals.append(createMeal(3, countValue: i))
        listOfMeals.append(dailyMeal)
        
        //DataHandler.createDailyMeal(dailyMeal)
        //week.dailyMeals.append(dailyMeal)
        }
        //DataHandler.createWeeklyMeal(week)
        
        return listOfMeals
    }
    
     //TO DO COMMENDTS
    static func createMeal(day:Int,countValue:Int)->Meal{
        
        
        let meal1 = Meal()
        
        meal1.name = "Meal " +  day.description
        
        meal1.foodItems.append(DataHandler.createFoodItem(DataHandler.getFood(1 % (day*countValue) + 1)! ,numberServing: 1.0));
        meal1.foodItems.append(DataHandler.createFoodItem(DataHandler.getFood(2 % (day*countValue) + 1)! ,numberServing: 1));
        meal1.foodItems.append(DataHandler.createFoodItem(DataHandler.getFood(3 % (day*countValue) + 1)! ,numberServing: 1));
        DataHandler.createMeal(meal1);
        return meal1;
        
    }
    
    //AIM < 400 lines of code
    
    /**
     This function assumes .
     
     
     - parameter foods: A List of Foods in the database that don't have 'oftenEatenWith' or 'alwaysEatenWithOneOf' yet.
     - parameter json: NSArray of foods and their attributes including.
     
     
     */
    static func createMealPlans(thisWeek:Week) -> [DailyMealPlan]{
        
        
        var plans : [DailyMealPlan] = []
        DataHandler.updateServingSizes()
        
        let realm = try! Realm()
        
        
        
        
        print(Realm.Configuration.defaultConfiguration.fileURL)

        
        // Get the data
        let likedFoods = DataHandler.getLikeFoods()
        let dislikedFoods = DataHandler.getDisLikedFoods().foods
        
        
        
        
        
        let macros = thisWeek.macroAllocation
        let kcal = Double(thisWeek.calorieAllowance)
        
        print("macros: \(macros) and kcal:\(kcal)")
        
        let bio = DataHandler.getActiveBiographical()
        let dietaryNeed = bio.dietaryMethod
        let desiredNumberOfDailyMeals = Double(bio.numberOfDailyMeals)
        
        //Predicates
        var listOfAndPredicates : [NSPredicate] = []
        var listOfORPredicates : [NSPredicate] = []
        let lowCarbPredicate = NSPredicate(format: "carbohydrates <= 5")
        let highCarbPredicate = NSPredicate(format: "carbohydrates > 15 AND fats < 5")
        let vegetablePredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.vegetableFoodType)
        let lowFatPredicate = NSPredicate(format: "fats < 5")
        let highProteinPredicate = NSPredicate(format: "(proteins > 20) AND (fats < 7) AND (carbohydrates < 7)")
        let middleOfTheRoadProteinTreat = NSPredicate(format: "(proteins BETWEEN {7, 15}) AND (fats < 5) AND (carbohydrates < 5)")
        
        let pureProteinsPredicate = NSPredicate(format: "(proteins > 15) AND (fats <= 4) AND (carbohydrates <= 4)")
        let pureFatsPredicate = NSPredicate(format: "(proteins < 5) AND (fats > 20) AND (carbohydrates < 5)")
        let pureCarbsPredicate = NSPredicate(format: "(proteins < 2) AND (fats < 2) AND (carbohydrates >= 10)")
        let drinkPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.drinkFoodType)
        
        
        let fatTreatPredicate = NSPredicate(format: "fats BETWEEN {15, 40} AND carbohydrates BETWEEN {4,10}")
        let carbTreatPredicate = NSPredicate(format: "carbohydrates BETWEEN {14, 80} AND fats BETWEEN {0, 8}")
        let likedFoodsPredicate = NSPredicate(format: "self.name in %@", likedFoods)
        let dislikedFoodsPredicate = NSPredicate(format: "NOT SELF.name IN %@", dislikedFoods)
        // let predicate = NSPredicate(format: "NOT name IN %@", namesStr)
        let dietaryNeedPredicate = NSPredicate(format: "self.dietSuitablity.name == %@", dietaryNeed!)
        let noPretFood = NSPredicate(format: "NOT name CONTAINS[c] 'PRET'")
        var compoundPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: listOfAndPredicates)
        let onlyBreakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.onlyBreakfastFoodType)
        let eatenAtBreakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.eatenAtBreakfastFoodType)
        
        //Bool
        //let random_yay_nay = arc4random_uniform(2)
        
        //Indices
        let proteinIndex = Constants.MACRONUTRIENTS.indexOf(Constants.PROTEINS)!
        let carbIndex = Constants.MACRONUTRIENTS.indexOf(Constants.CARBOHYDRATES)!
        let fatIndex = Constants.MACRONUTRIENTS.indexOf(Constants.FATS)!
        let vegIndex = Constants.MACRONUTRIENTS.indexOf(Constants.vegetableFoodType)!
        
        
        
        
        if desiredNumberOfDailyMeals > 5 {
            //return
        }
        
        // Create the desiredNumberOfDailyMeals for 7 days
        // Put this week into a Week object.
        // Do the same for next week.
        
        
            
        for dayIndex in 1...7 {
            let dailyMealPlan = DailyMealPlan()
            dailyMealPlan.dayId = dayIndex
            var numberOfMealsRemaining = Int(desiredNumberOfDailyMeals)
            
            
            //divide kcal required by number of meals, each one should not be +-20% of this
            var macrosDesiredToday : [String:Double] = [Constants.CALORIES:kcal, Constants.CARBOHYDRATES:macros[carbIndex].value, Constants.PROTEINS:macros[proteinIndex].value, Constants.FATS:macros[fatIndex].value/*Int(macros[2].value)*/]
            var macrosAllocatedToday = [Constants.CALORIES:0.0, Constants.CARBOHYDRATES:0.0, Constants.PROTEINS:0.0, Constants.FATS:0.0]
            
            
            for mealIndex in 1...Int(desiredNumberOfDailyMeals){
                
                print("Day \(dayIndex), meal \(mealIndex)")
                
                //var foodBasket :[String :[Food]] = [Constants.PROTEINS:[], Constants.CARBOHYDRATES:[],Constants.FATS:[], Constants.vegetableFoodType:[]]
                var foodBasket : [[Food]] = [ [], [], [], [] ]
                var sortedFoodBasket : [[Food]] = []
                var sortedFoodItemBasket : [[FoodItem]] = [ [], [], [], [] ]
                
                listOfORPredicates = []
                listOfAndPredicates = []
                listOfAndPredicates.appendContentsOf([dislikedFoodsPredicate, highProteinPredicate])
                
                if mealIndex == 1{
                    listOfAndPredicates.append(eatenAtBreakfastPredicate)
                    listOfAndPredicates.append(lowFatPredicate)
                    //listOfORPredicates.append(onlyBreakfastPredicate)
                }
                
                if mealIndex == Int(desiredNumberOfDailyMeals){
                    listOfAndPredicates.append(lowFatPredicate)
                    listOfAndPredicates.append(noPretFood)
                }
                
                let newAndCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfAndPredicates)
                //let newOrCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfORPredicates)
                
                
                let foodResults = realm.objects(Food).filter(newAndCompoundPredicate)//.filter(newOrCompoundPredicate)
                var randomNumber : UInt32 = arc4random_uniform(UInt32(foodResults.count))
                
                
                if foodResults.count > 0{
                    let p = foodResults[Int(randomNumber)]
                    //var pro = foodBasket[Constants.PROTEINS]
                    //var pro = foodBasket[proteinIndex]
                    //pro.append(p)
                    //foodBasket.insertContentsOf(p, at: proteinIndex)
                    foodBasket[proteinIndex].append(p)
                    
                    if p.alwaysEatenWithOneOf.count > 0{
                        // one of these must be choosen. It will be a carb because only carbs will be paired with protein sources.
                        let options = p.alwaysEatenWithOneOf.filter(dislikedFoodsPredicate)
                        randomNumber = arc4random_uniform(UInt32(options.count))
                        foodBasket[carbIndex].append(options[Int(randomNumber)])
                    }
                    
                    //Applies to all circumstances...if a high protein diet then get a second source of protein to mix it up
                    if macrosDesiredToday[Constants.PROTEINS] > 200 {
                        let random_yay_nay = Int(arc4random_uniform(2)) //if 0 then lets get a second food, else move on and just use one.
                        if random_yay_nay == 0 {
                            // ensure we don't select the same item
                            var newRandNum = arc4random_uniform(UInt32(foodResults.count))
                            while randomNumber == newRandNum {
                                newRandNum = arc4random_uniform(UInt32(foodResults.count))
                            }
                            // get a second one
                            foodBasket[proteinIndex].append(foodResults[Int(newRandNum)])
                        }
                        
                        
                    }
                    
                    
                    //Carbs if required FOR THIS MEAL!
                    let carbsNeededToday = macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!
                    let carbsRequiredSoFar = (macrosDesiredToday[Constants.CARBOHYDRATES]! / desiredNumberOfDailyMeals) * (desiredNumberOfDailyMeals - Double(numberOfMealsRemaining))
                    

                    
                    var carbsSoFarFromFoodBasket : Double = 0
                    for foodArray in foodBasket{
                        foodArrayEmpty: if foodArray.isEmpty{
                            break foodArrayEmpty
                        } else {
                            for food in foodArray{
                                carbsSoFarFromFoodBasket = carbsSoFarFromFoodBasket + food.carbohydrates
                            }
                        }
                    }
                    
                    let carbsApportionatedSoFar = dailyMealPlan.totalCarbohydrates() + carbsSoFarFromFoodBasket
                    var carbOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, highCarbPredicate]))
                    let OEWcarbOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, highCarbPredicate]))
                    //&& (carbsApportionatedSoFar <= Double(carbsRequiredSoFar))
                    if (carbsNeededToday > 0) && (carbOptions.count > 0) {
                        if OEWcarbOptions.count > 0{
                            carbOptions = OEWcarbOptions
                        }
                        randomNumber = arc4random_uniform(UInt32(carbOptions.count))
                        foodBasket[carbIndex].append(carbOptions[Int(randomNumber)])
                    }
                    
                    
                    

                    
                    //fats if required FOR THIS MEAL!
                    let fatsNeededToday = macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!
                    let fatsRequiredSoFar = (macrosDesiredToday[Constants.FATS]! / desiredNumberOfDailyMeals) * (desiredNumberOfDailyMeals - Double(numberOfMealsRemaining))
                    
                    var fatsSoFarFromFoodBasket : Double = 0
                    for foodArray in foodBasket{
                        foodArrayEmpty: if foodArray.isEmpty{
                            break foodArrayEmpty
                        } else {
                            for food in foodArray{
                                fatsSoFarFromFoodBasket = fatsSoFarFromFoodBasket + food.fats
                            }
                        }
                    }
                    
                    let fatsApportionatedSoFar = dailyMealPlan.totalFats() + fatsSoFarFromFoodBasket
                    var fatOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, fatTreatPredicate]))
                    let OEWfatOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, fatTreatPredicate]))
                    if (fatsNeededToday > 0) && (fatsApportionatedSoFar < Double(fatsRequiredSoFar)) && (fatOptions.count > 0) {
                        if OEWfatOptions.count > 0{
                            fatOptions = OEWfatOptions
                        }
                        randomNumber = arc4random_uniform(UInt32(fatOptions.count))
                        foodBasket[fatIndex].append(fatOptions[Int(randomNumber)])
                    }
                    
                    
                    //vegetables or fruit
                    if mealIndex > 1{
                        var vegetableOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, vegetablePredicate, lowCarbPredicate]))
                        let OEWvegetableOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, vegetablePredicate, lowCarbPredicate]))
                        if OEWvegetableOptions.count > 0{
                            vegetableOptions = OEWvegetableOptions
                        }
                        for vegetableIndex in 1...vegetableOptions.count{
                            if vegetableIndex < 4{
                                foodBasket[vegIndex].append(vegetableOptions[vegetableIndex])
                            }
                            break
                        }
                    }
                    
                    
                    /*
                        1.       Get food basket, 
                        2.       sort by non-gram items,
                        3.       determine how much of each nutrient for this meal,
                        4.       then scale up,
                        5.       create a food item,
                        6.       ask for preferred amount of this item that should be added,
                        7.       return all food items.
                     
                     
                     I want a table that says, meal 1 == over protein +15%, under carbs-15%, normal fats. meal 2 == under protein-15%, over carbs+15%, normal fats.
                    */
                    
                    
                    
                    
                    for foodArray in foodBasket{
                        foodArrayEmpty: if foodArray.isEmpty{
                            sortedFoodBasket.append([])// if any food group is empty then fill it with an empty as loop below depends on there being 4 in the order of constants.MACRONUTRIENTS
                            break foodArrayEmpty
                        } else {
                            var list = [String]()
                            
                            for each in foodArray{
                                list.append(each.name)
                            }
                            sortedFoodBasket.append(foodArray.sort(foodSort))
                        }
                    }
                    
                    
                    
                    
                    //divide kcal required by number of meals, each one should not be +-20% of this
                    var loop = 0
                    for foodArray in sortedFoodBasket{
                        
                        var overflow = [Double]() // You get this overflow limit for each meal, and its fixed, not for each food group.
                        //overflow.append(proteinDesiredFromThisFood)
                        //overflow.append(carbsDesiredFromThisFood)
                        //overflow.append(fatDesiredFromThisFood)
                        
                        let overflowP : Double
                        let overflowC : Double
                        let overflowF : Double
                        
                        
                        if numberOfMealsRemaining <= 2{
                            overflowP = (macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!)/Double(numberOfMealsRemaining)
                            overflowC = (macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!)/Double(numberOfMealsRemaining)
                            overflowF = (macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!)/Double(numberOfMealsRemaining)
                            //overflowP = (macrosDesiredToday[Constants.PROTEINS]!/desiredNumberOfDailyMeals)
                            //overflowC = (macrosDesiredToday[Constants.CARBOHYDRATES]!/desiredNumberOfDailyMeals)
                            //overflowF = (macrosDesiredToday[Constants.FATS]!/desiredNumberOfDailyMeals)
                        }
                        else {
                            overflowP = ((macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!)/Double(numberOfMealsRemaining)) * 1.1
                            overflowC = ((macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!)/Double(numberOfMealsRemaining)) * 1.1
                            overflowF = ((macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!)/Double(numberOfMealsRemaining)) * 1.1
                            //overflowP = (macrosDesiredToday[Constants.PROTEINS]!/desiredNumberOfDailyMeals) * 1.2
                            //overflowC = (macrosDesiredToday[Constants.CARBOHYDRATES]!/desiredNumberOfDailyMeals) * 1.2
                            //overflowF = (macrosDesiredToday[Constants.FATS]!/desiredNumberOfDailyMeals) * 1.2
                        }
                        
                        overflow.append(overflowP)
                        overflow.append(overflowC)
                        overflow.append(overflowF)

                        
                        
                        let key = Constants.MACRONUTRIENTS[loop]
                        
                        var findMoreFoods = false
                        if (foodArray.count > 0) && (key != Constants.vegetableFoodType) {
                            //Get the remaining amount left for today, for this macronutrient, and divide it amongst the remaining number of meals for today
                            let desiredToday = Double((macrosDesiredToday[key]!))
                            let allocatedtoday = Double((macrosAllocatedToday[key]!))
                            let desiredAmount = (desiredToday - allocatedtoday) / Double(numberOfMealsRemaining)
                            
                            // Carb overflow
                            let carbsDesiredToday = Double((macrosDesiredToday[Constants.CARBOHYDRATES]!))
                            let carbsAllocatedtoday = Double((macrosAllocatedToday[Constants.CARBOHYDRATES]!))
                            let carbsDesiredFromThisFood = (carbsDesiredToday - carbsAllocatedtoday) / Double(numberOfMealsRemaining)
                            // Fats overflow
                            let fatDesiredToday = Double((macrosDesiredToday[Constants.FATS]!))
                            let fatAllocatedtoday = Double((macrosAllocatedToday[Constants.FATS]!))
                            let fatDesiredFromThisFood = (fatDesiredToday - fatAllocatedtoday) / Double(numberOfMealsRemaining)
                            // Protein overflow
                            let proteinDesiredToday = Double((macrosDesiredToday[Constants.PROTEINS]!))
                            let proteinAllocatedtoday = Double((macrosAllocatedToday[Constants.PROTEINS]!))
                            let proteinDesiredFromThisFood = (proteinDesiredToday - proteinAllocatedtoday) / Double(numberOfMealsRemaining)
                            
                            
                            
                            
                            
                            //print("IMPORTANT \n desiredToday:\(desiredToday) \n allocatedtoday:\(allocatedtoday) \n desiredAmount:\(desiredAmount) \n")
                            
                            /*
                             Once the function has returned and the items summed, calculate the difference between what I would expect to see (the limit at the start) and what I just summed up, and add that back to overflow so the next loop takes this into consideration.
                             */

                            repeat {                                
                                //if the overflow for any attribute is less than 3g is it worth apportioning?
                                let results = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foodArray, attribute: key, desiredQuantity: desiredAmount, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday)
                                sortedFoodItemBasket.append(results.foodItems)
                                
                                for fi in results.foodItems{
                                    let ka = (fi.food?.calories)! * fi.numberServing
                                    let ca = (fi.food?.carbohydrates)! * fi.numberServing
                                    let pr = (fi.food?.proteins)! * fi.numberServing
                                    let fa = (fi.food?.fats)! * fi.numberServing
                                    
                                    overflow[0] = (overflow[0] - pr)
                                    overflow[1] = (overflow[1] - ca)
                                    overflow[2] = (overflow[2] - fa)
                                    
                                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                                }
                                
                                findMoreFoods = results.isAddittionalFoodRequired
                            } while findMoreFoods
                            
                            
                            
                            
                            //CHECK with delegate method before selection.
                            
                            // NOW NEED TO UPDATE - macrosAllocatedToday WITH fItem
                            
                        }
                        if key == Constants.vegetableFoodType{
                            var vegs = [FoodItem]()
                            for foo in foodArray{
                                let fooditem = FoodItem()
                                fooditem.food = foo
                                fooditem.numberServing = 0.5
                                vegs.append(fooditem)
                                
                                let ka = (fooditem.food?.calories)! * fooditem.numberServing
                                let ca = (fooditem.food?.carbohydrates)! * fooditem.numberServing
                                let pr = (fooditem.food?.proteins)! * fooditem.numberServing
                                let fa = (fooditem.food?.fats)! * fooditem.numberServing
                                
                                overflow[0] = (overflow[0] - pr)
                                overflow[1] = (overflow[1] - ca)
                                overflow[2] = (overflow[2] - fa)
                                
                                macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                                macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                                macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                                macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                            }
                            sortedFoodItemBasket.append(vegs)
                        }
                        
                        
                        
                        loop+=1
                    }
                    
                    
                    
                    
                    
                }
                else
                {
                    print("NO FOOD RESULTS FOUND")
                    
                }
                
                
                let meal = Meal()
                meal.name = "Meal " + String(mealIndex)
                
                var count = 0
                for foodArray in sortedFoodItemBasket{
                    
                    /*
                    for foodItem in foodArray{
                        
                        print("\(count):  \(foodItem.food!.name.capitalizedString), \n Serving size: \(foodItem.numberServing) \n Proteins: \(foodItem.food!.proteins*foodItem.numberServing), \n carbs: \(foodItem.food!.carbohydrates*foodItem.numberServing), \n fats: \(foodItem.food!.fats*foodItem.numberServing) \n kcal : \(foodItem.getTotalCal()) \n\n")
                    }
                    */
                    count = count+1
                    
                    
                    meal.foodItems.appendContentsOf(foodArray)
                    
                    
                }
                meal.date = NSCalendar.currentCalendar().dateByAddingUnit(.Day,value: Constants.DAYS_SINCE_START_OF_THIS_WEEK,toDate: Constants.START_OF_WEEK, options: [])!
                dailyMealPlan.meals.append(meal)
                print("Meal \(mealIndex) summary:\nCalories: \(meal.totalCalories())\nProtein: \(meal.totalProteins())\nCarbohydrates: \(meal.totalCarbohydrates())\nFats: \(meal.totalFats())\n")
                
                //end of each meal loop - 
                numberOfMealsRemaining = Int(desiredNumberOfDailyMeals) - mealIndex
            }
            
            var deficient : Double
            /*
             
             for macro in Constants.MACROS
             Switch:
             
             Determine the amount of protein we're deficient in
             Use predicate to find a food that has >25 <10 carbs and <5 fats
             Add this to two meals from the end
             
             Determine the amount of fats we're deficient in
             Use predicate to find a food that has >25 <5 carbs and <5 protein
             Add this to one meal from the end
             
             Determine the amount of carbs we're deficient in
             Use predicate to find a food that has >10 <5 protein and <5 fats
             Add this to the last meal
             
             */
            
            print("DailyMeal Plan m1:\nCalories: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
            
            for macro in Constants.MACRONUTRIENTS {
                
                
                switch macro {
                case Constants.PROTEINS:
                    deficient = macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!
                    
                    print("macrosDesiredToday[Constants.PROTEINS] = \(macrosDesiredToday[Constants.PROTEINS]!)")
                    
                    print("macrosAllocatedToday[Constants.PROTEINS]! = \(macrosAllocatedToday[Constants.PROTEINS]!)")
                    
                    guard deficient > 0  else {
                        break
                    }
                    let extraFood = realm.objects(Food).filter(pureProteinsPredicate).sorted(Constants.PROTEINS.lowercaseString, ascending: true)
                    let foodi = FoodItem()
                    let food :Food
                    
                    
                    if deficient < 20{
                        food = extraFood.first!
                    } else {
                        food = extraFood.last!
                    }
                    foodi.food = food
                    foodi.numberServing = (deficient/(food.proteins))
                    print("PROTEIN foodi: \(foodi.food!.name) with \(foodi.numberServing). Deficient in: \(deficient)")
                    (dailyMealPlan.meals.reverse()[2]).foodItems.append(foodi)
                    
                    let ka = ((foodi.food!.calories) * foodi.numberServing)
                    let ca = ((foodi.food!.carbohydrates) * foodi.numberServing)
                    let pr = ((foodi.food!.proteins) * foodi.numberServing)
                    let fa = ((foodi.food!.fats) * foodi.numberServing)
                    
                    print("2. Just added: \(pr)g of protein to the meal")
                    print("2. macrosDesiredToday[Constants.PROTEINS] = \(macrosDesiredToday[Constants.PROTEINS]!)")
                    
                    print("2. macrosAllocatedToday[Constants.PROTEINS]! = \(macrosAllocatedToday[Constants.PROTEINS]!)")
                    
                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                    //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    
                    print("DailyMeal Plan m2:\nCalories: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
                    
                    
                case Constants.CARBOHYDRATES:
                    
                    deficient = macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!
                    let extraFood = realm.objects(Food).filter(pureCarbsPredicate).sorted(Constants.CARBOHYDRATES.lowercaseString, ascending: true)
                    
                    let randomNumber : UInt32 = arc4random_uniform(UInt32(extraFood.count))
                    var newRandNum = arc4random_uniform(UInt32(extraFood.count))
                    while randomNumber == newRandNum {
                        newRandNum = arc4random_uniform(UInt32(extraFood.count))
                    }
                    
                    //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    
                    let foodi = FoodItem()
                    let food :Food
                    guard deficient > 0  else {
                        break
                    }
                    if deficient < 3 {
                        break
                    }
                    if deficient < 20{
                        food = extraFood.first!
                    } else {
                        food = extraFood.last!
                    }
                    foodi.food = food
                    foodi.numberServing = (deficient/(food.carbohydrates)) // just because it tends to be a little high
                    print("CARBOHYDRATES foodi: \(foodi.food!.name) with \(foodi.numberServing). Deficient in: \(deficient)")
                    (dailyMealPlan.meals.last!.foodItems.append(foodi))
                    
                    let ka = ((foodi.food!.calories) * foodi.numberServing)
                    let ca = ((foodi.food!.carbohydrates) * foodi.numberServing)
                    let pr = ((foodi.food!.proteins) * foodi.numberServing)
                    let fa = ((foodi.food!.fats) * foodi.numberServing)
                    
                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                    
                    print("DailyMeal Plan m3:\nCalories: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
                    
                    
                case Constants.FATS:
                    deficient = macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!
                    let extraFood = realm.objects(Food).filter(pureFatsPredicate).sorted(Constants.FATS.lowercaseString, ascending: true)
                    //TODO: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    let foodi = FoodItem()
                    let food : Food
                    guard deficient > 0  else {
                        break
                    }
                    
                    if deficient < 3 {
                        break
                    }
                    if deficient < 20{
                        food = extraFood.first!
                    } else {
                        food = extraFood.last!
                    }
                    
                    //TODO: call apportion method and then use the results below
                    foodi.food = food
                    foodi.numberServing = (deficient/(food.fats))
                    print("FATS foodi: \(foodi.food!.name) with \(foodi.numberServing). Deficient in: \(deficient)")
                    (dailyMealPlan.meals.reverse()[1]).foodItems.append(foodi)
                    
                    
                    //When comfortable, this is not necessary as it's the last macro. But check it is the last macro!
                    let ka = ((foodi.food!.calories) * foodi.numberServing)
                    let ca = ((foodi.food!.carbohydrates) * foodi.numberServing)
                    let pr = ((foodi.food!.proteins) * foodi.numberServing)
                    let fa = ((foodi.food!.fats) * foodi.numberServing)
                    
                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                    
                    print("DailyMeal Plan:\nCalories m4: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
                    
                case Constants.vegetableFoodType:
                    print("vegetables macro")
                    //break
                    
                default:
                    print("ERROR: No macro found.")
                }
            }
            
            //TODO: Ensure that proteins has -10 by the time I get to the first pass of proteing in meal 4
            
            print("DailyMeal Plan:\nCalories: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
            
            plans.append(dailyMealPlan)
            //thisWeek.dailyMeals.append(dailyMealPlan)
            
            
        }
        return plans
    }
    
    
    
    static func foodSort(f1: Food, _ f2: Food) -> Bool {
        let order = Constants.SERVING_SIZE_ORDER
        return order.indexOf((f1.servingSize?.name)!)! < order.indexOf((f2.servingSize?.name)!)!
    }
   
    

                        
    func addNewPredicateToCompound(predicate:NSPredicate, compoundPredicate:NSCompoundPredicate) -> NSCompoundPredicate{
        
        var subPredicates : [NSPredicate] = []
        subPredicates.appendContentsOf(compoundPredicate.subpredicates as! [NSPredicate])
        let cPredicate : NSCompoundPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates:subPredicates)
        return cPredicate
    }
    
    
    /**
     This function assesses whether a food is alwaysEatenWith or has been used excessively so far. For example Bread, fat:20g will return a fooditem that contains enough bread to give 20g of fat.
     
     
     - parameter food: A food object.
     - parameter attribute: 'carbs', 'proteins', or 'fats'.
     - parameter desiredQuantity: ...
     
     */
    
    
    /*
     TODO:  IF ITEM IS ALWAYSEATENWITHONEOF
    , then find the item with the lowest calories, see if that can fit into my calories left for today.
     If so, then add it, if not, return - false - you can't add this item to your meal.
    */
    func shouldAllowAdditionToMeal(dailymeal:DailyMealPlan, food:Food, basket:[Food], macrosDict:[String:Double], week:Week) ->Bool{
        
        let foodsToConsider = food.alwaysEatenWithOneOf
        var foodsGoodToGo : [Food] = []
        
        
        for fc in foodsToConsider {
            if (basket.contains(fc)) {
                foodsGoodToGo.append(fc)
            }
        }
        /*
        guard (foodsGoodToGo.count > 0) else {
            return
        }
        
        for food in foodsGoodToGo {
            
        }
        // if fc fits macros, continue, else return false
        for macro in constants.macros {
            let remaining = macros[macro]
            
        }
 
        }
 */
    
        // set limits on the amount per meal
    
        // get count of all foods eaten this week
        var foodIsFromToday:Bool?
        var listOfFoodsFromToday : [Food] = []
        var listOfFoodsFromThisWeek : [Food] = []
        for dailyMeal in week.dailyMeals{
            let dateOfMealPlan = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: dailyMeal.dayId,toDate: week.start_date, options: [])
            foodIsFromToday = NSCalendar.currentCalendar().isDateInToday(dateOfMealPlan!)
            for meal in dailyMeal.meals{
                for fooditem in meal.foodItems {
                    listOfFoodsFromThisWeek.append(fooditem.food!)
                    //(foodIsFromToday)? listOfFoodsFromToday.append(fooditem.food): pass
                    if foodIsFromToday == true {
                        listOfFoodsFromToday.append(fooditem.food!)
                    }
                }
            }
        }
        
        //today
        let predicate = NSPredicate(format: "self == %@", food)
        let foodCountToday = (listOfFoodsFromToday as NSArray).filteredArrayUsingPredicate(predicate).count
        let foodCountThisWeek = (listOfFoodsFromThisWeek as NSArray).filteredArrayUsingPredicate(predicate).count
        if (foodCountToday > 2) || (foodCountThisWeek > 4)  {
            return false
        }
        else {
            return true
        }
        
    }

    /**
    This function takes a given food and returns a fooditem with the given amount of a macro. For example Bread, fat:20g will return a fooditem that contains enough bread to give 20g of fat.
    
    
    - parameter food: A food object.
    - parameter attribute: 'carbs', 'proteins', or 'fats'.
    - parameter desiredQuantity: ...
     
    
    
    */
    static func apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foods:[Food], attribute:String, desiredQuantity:Double, overflowAmounts:[Double], macrosAllocatedToday:[String:Double])->(foodItems:[FoodItem], isAddittionalFoodRequired:Bool)
    {
        
        
        var overflow = overflowAmounts
        var moreFoodsRequired = false
        var foodItems : [FoodItem] = []
        // Need to update the overflowAmounts variable if there are more than one foods
        
        
        foodloop: for food in foods {
            print("Name: \(food.name)\nAttribute: \(attribute) \nDesiredQuantity:\(desiredQuantity)\nOverflowAmounts:\(overflow) \nMacrosAllocatedToday:\(macrosAllocatedToday)")
            var foodAttributeAmount = Double()
            switch attribute {
            case Constants.CARBOHYDRATES:
                foodAttributeAmount = food.carbohydrates
            case Constants.PROTEINS:
                foodAttributeAmount = food.proteins
            case Constants.FATS:
                foodAttributeAmount = food.fats
            default:
                foodAttributeAmount = food.carbohydrates
                print("ERROR IN apportionFoodToGetGivenAmountOfMacro")
            }
            
           
            
            let fooditem = FoodItem()
            fooditem.food = food
            fooditem.numberServing = (desiredQuantity/Double(foods.count))/foodAttributeAmount // so its divided amonst the # of foods for this macro
            // But not allowed to overflow, so...
            for (index, macroLimit) in overflow.enumerate(){
                var macroAmount = Double()
                switch index { // static let MACRONUTRIENTS = ["Proteins", "Carbohydrates", "Fats", "Vegetable"]
                case 0:
                    macroAmount = food.proteins
                case 1:
                    macroAmount = food.carbohydrates
                case 2:
                    macroAmount = food.fats
                default:
                    macroAmount = food.fats
                }
                
                print("Equation: (fooditem.numberServing: \(fooditem.numberServing) * macroAmount:\(macroAmount) )")
                print("Assess: \((fooditem.numberServing * macroAmount)) > \(Double(macroLimit))")
                
                //Only scale if the macrolimit isnt a silly number like less than 3g as this could make the amount scaled down to really small.
                //As extra safety, consider ensuring that the numberserving is no less than 0.05
                if macroLimit > 3 {
                    
                    if Constants.MACRONUTRIENTS[index] == Constants.PROTEINS {
                        while (fooditem.numberServing * macroAmount)  > (Double(macroLimit) - 10) {
                            //we need to scale this down!
                            //print("\nGUARDING AGAINST EXCESS: \(Constants.MACRONUTRIENTS[index])\n")
                            //print("Equation: (fooditem.numberServing: \(fooditem.numberServing) * macroAmount:\(macroAmount) )\n")
                            //print("Summary equation: \((fooditem.numberServing * macroAmount)) > \(Double(macroLimit)) \n\n")
                            fooditem.numberServing = (fooditem.numberServing - 0.01)
                        }
                    } else {
                        while (fooditem.numberServing * macroAmount)  > Double(macroLimit) {
                            //we need to scale this down!
                            //print("\nGUARDING AGAINST EXCESS: \(Constants.MACRONUTRIENTS[index])\n")
                            //print("Equation: (fooditem.numberServing: \(fooditem.numberServing) * macroAmount:\(macroAmount) )\n")
                            //print("Summary equation: \((fooditem.numberServing * macroAmount)) > \(Double(macroLimit)) \n\n")
                            fooditem.numberServing = (fooditem.numberServing - 0.01)
                        }
                    }
                    
                    
                    //print("Now \(Constants.MACRONUTRIENTS[index]) is low enough.\n This item will have:\n\(fooditem.numberServing*food.proteins)g of protein\n\(fooditem.numberServing*food.carbohydrates)g of carbs\n\(fooditem.numberServing*food.fats)g of fats\n\n\n")
                } else {
                    print("SKIPPING as the macrolimit is too small to scale.")
                    break foodloop
                }
            }
            
            
            
            
            if (food.servingSize?.name != Constants.grams) && (food.servingSize?.name != Constants.ml) {
                //round up to the closet whole number as we can only have 1 egg, or 2 pots etc
                fooditem.numberServing = ceil(desiredQuantity/foodAttributeAmount)
            }
            
            if Constants.isFat.evaluateWithObject(food){
                fooditem.numberServing = 0.1 //10g or 10ml of fat
                moreFoodsRequired = true
            }
            DataHandler.createFoodItem(fooditem)
            foodItems.append(fooditem)
            
            overflow[0] = overflow[0] - (fooditem.numberServing * food.proteins)
            overflow[1] = overflow[1] - (fooditem.numberServing * food.carbohydrates)
            overflow[2] = overflow[2] - (fooditem.numberServing * food.fats)
            
            if desiredQuantity < (fooditem.numberServing * foodAttributeAmount) {
                //TODO: Uncomment this if it works. And delete the moreFoodsRequired under isFat
                //moreFoodsRequired = true
                print("Potential error, check this out.")
                print("Desired Quantity = \(desiredQuantity), and what I'm getting = \((fooditem.numberServing * foodAttributeAmount))")
            }
        }
        
        return (foodItems, moreFoodsRequired)
    }
 
 

    
    static func getMeal()->[Meal]{
        return DataHandler.readMealData();
    }
    
    func  randomQuantity() -> Double
    {
        let r = (Double) (arc4random() % 11) + 100
        return r
    }
    
    static func calculateTotalCalories( items :[Meal])->Double{
        var count = 0.0;
        for food in items{
            count +=  getcalory(food.foodItems)
        }
        return count;
    }
   static func getcalory(items :List<FoodItem>)->Double{
        var count = 0.0;
        for food in items{
            count +=  food.food!.calories * food.numberServing
        }
        return count;
        }
}




