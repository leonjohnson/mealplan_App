import UIKit
import RealmSwift

class DataStructure : NSObject{
    
    
    static func createOverFlowStructure(numberOfMealsRemaining:Int,macrosAllocatedToday:[String:Double], macrosDesiredToday:[String:Double]) -> [Double]{
        var overflow = [Double]() // You get this overflow limit for each meal, and its fixed, not for each food group.
        //overflow.append(proteinDesiredFromThisFood)
        //overflow.append(carbsDesiredFromThisFood)
        //overflow.append(fatDesiredFromThisFood)
        
        let overflowP : Double
        let overflowC : Double
        let overflowF : Double
        
        
        
        overflowP = ((macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!)/Double(numberOfMealsRemaining))
        overflowC = ((macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!)/Double(numberOfMealsRemaining))
        overflowF = ((macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!)/Double(numberOfMealsRemaining))
        
        
        overflow.append(overflowP)
        overflow.append(overflowC)
        overflow.append(overflowF)
        
        return overflow
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
        
        
        var csv1 : String = ""
        var csv2 : String = ""
        var csv3 : String = ""
        
        var plans : [DailyMealPlan] = []
        DataHandler.updateServingSizes()
        
        let realm = try! Realm()
        
        
        
        
        print(Realm.Configuration.defaultConfiguration.fileURL)

        
        
        //let likedFoods = DataHandler.getLikeFoods() //TODO: SHOW USERS FOODS THAT HE LIKES
        let dislikedFoods = DataHandler.getDisLikedFoods().foods
        let onlyBreakfastFoods = DataHandler.getBreakfastOnlyFoods()
        
        
        
        
        
        let macros = thisWeek.macroAllocation
        let kcal = Double(thisWeek.calorieAllowance)
        
        print("macros: \(macros) and kcal:\(kcal)")
        
        let bio = DataHandler.getActiveBiographical()
        _ = bio.dietaryRequirement
        let desiredNumberOfDailyMeals = Double(bio.numberOfDailyMeals)
        
        //Predicates
        var listOfAndPredicates : [NSPredicate] = []
        let lowCarbPredicate = NSPredicate(format: "carbohydrates <= 5")
        let highCarbPredicate = NSPredicate(format: "carbohydrates > 15 AND fats < 9") //Used to search only the foods associated with the choosen protein source
        let lowFatPredicate = NSPredicate(format: "fats < 5")
        let highFatPredicate = NSPredicate(format: "fats BETWEEN {15, 40} AND carbohydrates BETWEEN {4,10}")
        let carbTreatPredicate = NSPredicate(format: "carbohydrates BETWEEN {8, 80} AND fats BETWEEN {0, 5}") // Used to search across all foods in db
        let vegetablePredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.vegetableFoodType)
        let denseProteinPredicate = NSPredicate(format: "(proteins > 20) AND (fats < 4) AND (carbohydrates < 7)")
        let highProteinPredicate = NSPredicate(format: "(proteins > 20) AND (fats < 7) AND (carbohydrates < 7)")
        let lightProteinTreat = NSPredicate(format: "(proteins BETWEEN {7, 20}) AND (fats < 8) AND (carbohydrates < 8)")
        let notOnlyBreakfastPredicate = NSPredicate(format: "NONE SELF.foodType.name == [c] %@", onlyBreakfastFoods)
        let notCondiment = NSPredicate(format: "NONE SELF.foodType.name == [c] %@", Constants.condiment)
        let readyToEatPredicate = NSPredicate(format: "readyToEat == %@", NSNumber(bool: true))
        //http://stackoverflow.com/questions/6169121/how-to-write-a-bool-predicate-in-core-data
        let vegetarianPredicate = NSPredicate(format: "ANY SELF.dietSuitablity.name == [c] %@", Constants.vegetarian)
        
        
        /*
        let noPretFood = NSPredicate(format: "NOT name CONTAINS[c] 'PRET'")
        let pureFatsPredicate = NSPredicate(format: "(proteins < 5) AND (fats > 20) AND (carbohydrates < 5)")
        let pureCarbsPredicate = NSPredicate(format: "(proteins < 2) AND (fats < 2) AND (carbohydrates >= 10)")
        let drinkPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.drinkFoodType)
        let dietaryNeedPredicate = NSPredicate(format: "self.dietSuitablity.name == %@", dietaryNeed!)
        
        let likedFoodsPredicate = NSPredicate(format: "self.name in %@", likedFoods)
        */
        let dislikedFoodsPredicate = NSPredicate(format: "NOT SELF.name IN %@", dislikedFoods)
 
        

        let eatenAtBreakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.eatenAtBreakfastFoodType)
        /*
        let dynamicProteinPredicate = NSPredicate {
            (evaluatedObject, _) in
            let food = (evaluatedObject as! Food)
            return food.proteins <= food.fats*1.1 && (food.proteins >= food.fats*0.9) || (food.proteins >= 10)
            /* Terminating app due to uncaught exception 'Invalid predicate', reason: 'Only support compound, comparison, and constant predicates'*/
        }
 */
         
        
        
        let mediumBreakfastProteinPredicate = NSPredicate(format: "(proteins >= 8) AND (fats <= 6) OR (proteins >= 21) AND (fats <= 21) OR (proteins >= 24) AND (fats <= 18)")
        
        
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
        
        
        // CREATE PREDICATES
        let compoundPredForCarbs = NSCompoundPredicate(andPredicateWithSubpredicates: [carbTreatPredicate, dislikedFoodsPredicate, notCondiment, readyToEatPredicate])
        let compoundPredForProteins = NSCompoundPredicate(andPredicateWithSubpredicates: [lightProteinTreat, dislikedFoodsPredicate, vegetarianPredicate, notCondiment])
        
        let extraCarbTreats = realm.objects(Food).filter(compoundPredForCarbs)
        var lightProteins = realm.objects(Food).filter(compoundPredForProteins)
        
            
        for dayIndex in 1...7 {
            var dailyMealPlan = DailyMealPlan()
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
                
                listOfAndPredicates = []
                listOfAndPredicates.appendContentsOf([dislikedFoodsPredicate, notCondiment, highProteinPredicate])
                
                if mealIndex == 1{
                    listOfAndPredicates.popLast()
                    listOfAndPredicates.appendContentsOf([mediumBreakfastProteinPredicate, eatenAtBreakfastPredicate])
                } else{
                    //listOfAndPredicates.append(notOnlyBreakfastPredicate)
                }
                
                if mealIndex == Int(desiredNumberOfDailyMeals){
                    listOfAndPredicates.append(lowFatPredicate)
                }
                
                let newAndCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfAndPredicates)
                //let newOrCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfORPredicates)
                
                
                let foodResults = realm.objects(Food).filter(newAndCompoundPredicate)//.filter(newOrCompoundPredicate)
                var randomNumber : UInt32 = arc4random_uniform(UInt32(foodResults.count))
                
                guard foodResults.count > 0 else {
                    break
                }
                let p = foodResults[Int(randomNumber)]
                foodBasket[proteinIndex].append(p)
                print("Protein selected is : \(p.name) ")
                if p.alwaysEatenWithOneOf.count > 0{
                    let options = p.alwaysEatenWithOneOf.filter(dislikedFoodsPredicate)
                    randomNumber = arc4random_uniform(UInt32(options.count))
                    //TODO: Place this AEWOO in the right basket
                    
                    //TODO: CHECK with delegate method before selection.
                    foodBasket[carbIndex].append(options[Int(randomNumber)])
                }
                
                //Get a number of light protein snacks throughout the day
                
                var random_yay_nay = Int(arc4random_uniform(3)) //if 0 t1hen lets get a second food, else move on and just use one.
                if random_yay_nay == 0 {
                    // ensure we don't select the same item
                    
                    var newRandNum = arc4random_uniform(UInt32(lightProteins.count))
                    if lightProteins.count == 0{
                        lightProteins = foodResults
                    }
                    newRandNum = arc4random_uniform(UInt32(lightProteins.count))
                    let newFood = lightProteins[Int(newRandNum)]
                    print("Second protein selected under random_yay_nay : \(newFood.name) ")
                    
                    if foodBasket[proteinIndex].contains(newFood) == false {
                        foodBasket[proteinIndex].append(newFood)
                        if newFood.alwaysEatenWithOneOf.count > 0{
                            newRandNum = arc4random_uniform(UInt32(newFood.alwaysEatenWithOneOf.count))
                            let selectedFood = newFood.alwaysEatenWithOneOf[Int(newRandNum)]
                            
                            if selectedFood.foodType.contains(DataHandler.getFoodType(Constants.vegetableFoodType)) {
                                foodBasket[vegIndex].append(selectedFood)
                            }
                            
                            else if selectedFood.proteins > selectedFood.fats && selectedFood.proteins > selectedFood.carbohydrates{
                                foodBasket[proteinIndex].append(selectedFood)
                            }
                            else if selectedFood.carbohydrates > selectedFood.fats && selectedFood.carbohydrates > selectedFood.proteins{
                                foodBasket[carbIndex].append(selectedFood)
                            }
                            else if selectedFood.fats > selectedFood.carbohydrates && selectedFood.fats > selectedFood.proteins{
                                foodBasket[fatIndex].append(selectedFood)
                            }
                        }
                    }
                    
                }
                
                
                
                
                
                
                
                    
                
                //Carbs if required FOR THIS MEAL!
                let carbsNeededToday = macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!
                
                //This code stub can be deleted as it's not used anywhere.
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
                
                //let carbsApportionatedSoFar = dailyMealPlan.totalCarbohydrates() + carbsSoFarFromFoodBasket
                var carbPredicateList = [dislikedFoodsPredicate, highCarbPredicate, notCondiment]
                if mealIndex == 1{
                    carbPredicateList.append(eatenAtBreakfastPredicate)
                }
                var carbOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: carbPredicateList))
                let OEWcarbOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: carbPredicateList))
                //&& (carbsApportionatedSoFar <= Double(carbsRequiredSoFar))
                if (carbsNeededToday > 0) && (carbOptions.count > 0) {
                    if OEWcarbOptions.count > 0{
                        print("OEWcarbOptions COUNT: \(OEWcarbOptions.count)")
                        carbOptions = OEWcarbOptions
                    }
                    
                    print("foods from which I'll select a carb:")
                    for f in carbOptions{
                        print("\(f.name)")
                    }
                    randomNumber = arc4random_uniform(UInt32(carbOptions.count))
                    let foodSelected = carbOptions[Int(randomNumber)]
                    
                    print("Picking : \(foodSelected.name)")
                    
                    foodBasket[carbIndex].append(foodSelected)
                    
                    foodSelectedBreak: if foodSelected.alwaysEatenWithOneOf.count > 0{
                        randomNumber = arc4random_uniform(UInt32(foodSelected.alwaysEatenWithOneOf.count))
                        let selectedFood = foodSelected.alwaysEatenWithOneOf[Int(randomNumber)]
                        
                        if selectedFood.foodType.contains(DataHandler.getFoodType(Constants.vegetableFoodType)){
                            foodBasket[vegIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                        
                        if selectedFood.proteins > selectedFood.fats && selectedFood.proteins > selectedFood.carbohydrates{
                            foodBasket[proteinIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                        if selectedFood.carbohydrates > selectedFood.fats && selectedFood.carbohydrates > selectedFood.proteins{
                            foodBasket[carbIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                        if selectedFood.fats > selectedFood.carbohydrates && selectedFood.fats > selectedFood.proteins{
                            foodBasket[fatIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                    }
                }
                
                
                random_yay_nay = Int(arc4random_uniform(3)) //if 0 t1hen lets get a second food, else move on and just use one.
                if random_yay_nay == 0 && extraCarbTreats.count > 0 {
                    var newRandNum = arc4random_uniform(UInt32(extraCarbTreats.count))
                    let newFood = extraCarbTreats[Int(newRandNum)]
                    
                    
                    foodBreak: for f in foodBasket[carbIndex]{
                        // the first item found that we dont have
                        if newFood != f{
                            foodBasket[carbIndex].append(newFood)
                            
                            if newFood.alwaysEatenWithOneOf.count > 0{
                                newRandNum = arc4random_uniform(UInt32(newFood.alwaysEatenWithOneOf.count))
                                let selectedFood = newFood.alwaysEatenWithOneOf[Int(newRandNum)]
                                
                                if selectedFood.foodType.contains(DataHandler.getFoodType(Constants.vegetableFoodType)){
                                    foodBasket[vegIndex].append(selectedFood)
                                    break foodBreak
                                }
                                
                                if selectedFood.proteins > selectedFood.fats && selectedFood.proteins > selectedFood.carbohydrates{
                                    foodBasket[proteinIndex].append(selectedFood)
                                    break foodBreak
                                }
                                if selectedFood.carbohydrates > selectedFood.fats && selectedFood.carbohydrates > selectedFood.proteins{
                                    foodBasket[carbIndex].append(selectedFood)
                                    break foodBreak
                                }
                                if selectedFood.fats > selectedFood.carbohydrates && selectedFood.fats > selectedFood.proteins{
                                    foodBasket[fatIndex].append(selectedFood)
                                    break foodBreak
                                }
                            }
                        }
                    }
                    
                }
                
                
                
                
                
                
                

                
                //fats if required FOR THIS MEAL!
                var fatPredicateList = [dislikedFoodsPredicate, highFatPredicate]
                if mealIndex == 1{
                    fatPredicateList.append(eatenAtBreakfastPredicate)
                }

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
                var fatOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: fatPredicateList))
                let OEWfatOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: fatPredicateList))
                if (fatsNeededToday > 0) && (fatsApportionatedSoFar < Double(fatsRequiredSoFar)) && (fatOptions.count > 0) {
                    if OEWfatOptions.count > 0{
                        fatOptions = OEWfatOptions
                    }
                    randomNumber = arc4random_uniform(UInt32(fatOptions.count))
                    let fatSelected = fatOptions[Int(randomNumber)]
                    foodBasket[fatIndex].append(fatSelected)
                    
                    
                    foodSelectedBreak: if fatSelected.alwaysEatenWithOneOf.count > 0{
                        randomNumber = arc4random_uniform(UInt32(fatSelected.alwaysEatenWithOneOf.count))
                        let selectedFood = fatSelected.alwaysEatenWithOneOf[Int(randomNumber)]
                        
                        if selectedFood.foodType.contains(DataHandler.getFoodType(Constants.vegetableFoodType)){
                            foodBasket[vegIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                        
                        if selectedFood.proteins > selectedFood.fats && selectedFood.proteins > selectedFood.carbohydrates{
                            foodBasket[proteinIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                        if selectedFood.carbohydrates > selectedFood.fats && selectedFood.carbohydrates > selectedFood.proteins{
                            foodBasket[carbIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                        if selectedFood.fats > selectedFood.carbohydrates && selectedFood.fats > selectedFood.proteins{
                            foodBasket[fatIndex].append(selectedFood)
                            break foodSelectedBreak
                        }
                    }
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
                        //break
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
                
                
                
                //TODO: REFACTOR. We can ensure that the below is only used for debugging. Sorting should come at the end.
                
                for foodArray in foodBasket{
                    foodArrayEmpty: if foodArray.isEmpty{
                        sortedFoodBasket.append([])// if any food group is empty then fill it with an empty as loop below depends on there being 4 in the order of constants.MACRONUTRIENTS
                        break foodArrayEmpty
                    } else {
                        
                        for food in foodArray{
                            csv1 += food.name + ","
                        }
                        
                        sortedFoodBasket.append(foodArray.sort(foodSortByServingType))
                    }
                }
                csv1 += "\n"
                
                
                
                
                
                
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
                    
                    
                    
                    overflowP = ((macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!)/Double(numberOfMealsRemaining))
                    overflowC = ((macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!)/Double(numberOfMealsRemaining))
                    overflowF = ((macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!)/Double(numberOfMealsRemaining))

                    
                    overflow.append(overflowP)
                    overflow.append(overflowC)
                    overflow.append(overflowF)

                    
                    
                    
                    let key = Constants.MACRONUTRIENTS[loop]
                    print("\(key.capitalizedString) loop: \n P:\(overflowP) C:\(overflowC) F:\(overflowF)")
                    
                    if (foodArray.count > 0) && (key != Constants.vegetableFoodType) {
                        //Get the remaining amount left for today, for this macronutrient, and divide it amongst the remaining number of meals for today
                        let desiredToday = Double((macrosDesiredToday[key]!))
                        let allocatedtoday = Double((macrosAllocatedToday[key]!))
                        let desiredAmount = (desiredToday - allocatedtoday) / Double(numberOfMealsRemaining)
                        
                        
                        // Not negative and not tiny amounts
                        if desiredToday > 1{
                            let results = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foodArray, attribute: key, desiredQuantity: desiredAmount, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday)
                            sortedFoodItemBasket.append(results)
                            
                            for fi in results{
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
                        }
                        
                        

                        
                        
                        
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
                
                
                for foodArray in sortedFoodItemBasket{
                    for foodItem in foodArray{
                        csv2 += (foodItem.food?.name)! + ","
                    }
                    
                }
                csv2 += "\n"
                
                
                
                
                let meal = Meal()
                meal.name = "Meal " + String(mealIndex)
                
                var count = 0
                for foodArray in sortedFoodItemBasket{
                    
                    
                    for foodItem in foodArray{
                        
                        print("\(count):  \(foodItem.food!.name.capitalizedString), \n Serving size: \(foodItem.numberServing) \n Proteins: \(foodItem.food!.proteins*foodItem.numberServing), \n carbs: \(foodItem.food!.carbohydrates*foodItem.numberServing), \n fats: \(foodItem.food!.fats*foodItem.numberServing) \n kcal : \(foodItem.getTotalCal()) \n\n")
                    }
                    
                    count = count+1
                    
                    //meal.appendOrCombineFoodItems(foodArray)
                    meal.foodItems.appendContentsOf(foodArray)
                    
                    
                }
                meal.date = NSCalendar.currentCalendar().dateByAddingUnit(.Day,value: Constants.DAYS_SINCE_START_OF_THIS_WEEK,toDate: Constants.START_OF_WEEK, options: [])!
                
                dailyMealPlan.meals.append(meal)
                

                
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
            
            
            
            
            // THE COMEBACK!

            
            for macro in Constants.MACRONUTRIENTS {
                var foodsAlreadySelected :[Food] = []
                for each in dailyMealPlan.foods(){
                    foodsAlreadySelected.append(each)
                }
                
                //let foodsAlreadySelectedPred = NSPredicate(format: "NOT SELF IN %@", foodsAlreadySelected)
                
                breakLabel: switch macro {
                case Constants.PROTEINS: // TODO - DELETE as this should never be called.
                    deficient = macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!

                    //let dPredicate : NSCompoundPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates:[pureProteinsPredicate,])
                    //let extraFoods = realm.objects(Food).filter(dPredicate).sorted(Constants.PROTEINS.lowercaseString, ascending: true)
                    var comeBackProteinFoodItem = FoodItem()
                    var food :Food = Food()
                    
                    guard deficient > 0  else {
                        break breakLabel
                    }
                    
                    if deficient < Constants.maximumNumberOfGramsToIgnore {
                        break breakLabel
                    }
                    else if deficient >= 20{
                        for fo in lightProteins.reverse(){
                            if foodsAlreadySelected.contains(fo) == false && fo.alwaysEatenWithOneOf.count == 0{
                                food = fo
                                break
                            }
                        }
                        
                    } else {
                        for fo in lightProteins{
                            if foodsAlreadySelected.contains(fo) == false && fo.alwaysEatenWithOneOf.count == 0{
                                food = fo
                                break
                            }
                        }
                    }
                    
                    if food.name == ""{
                        print("Possibly at 0")
                        let randomInt = Int(arc4random_uniform(UInt32(lightProteins.count)))
                        food = lightProteins[randomInt]
                    }
                    comeBackProteinFoodItem.food = food
                    comeBackProteinFoodItem.numberServing = (deficient/(food.proteins))
                    let overflow = createOverFlowStructure(numberOfMealsRemaining, macrosAllocatedToday: macrosAllocatedToday, macrosDesiredToday: macrosDesiredToday)
                    
                    let fi = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow([food], attribute: macro, desiredQuantity: deficient, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday)
                    
                    if fi.count > 0 {
                        comeBackProteinFoodItem = fi.first!
                    }
                    
                    /*
                    if (food.servingSize?.name != Constants.grams) && (food.servingSize?.name != Constants.ml) {
                        //round up to the closet whole number as we can only have 1 egg, or 2 pots etc
                        if comeBackProteinFoodItem.numberServing > 0 && comeBackProteinFoodItem.numberServing < 1  {
                            comeBackProteinFoodItem.numberServing = ceil(deficient/(food.carbohydrates))
                        }
                        else {
                            comeBackProteinFoodItem.numberServing = floor(deficient/(food.carbohydrates))
                        }
                    }
                    */
                    dailyMealPlan = assignMealTo(Constants.PROTEINS, foodItem: comeBackProteinFoodItem, plan: dailyMealPlan)
                    
                    

                    let ka = ((comeBackProteinFoodItem.food!.calories) * comeBackProteinFoodItem.numberServing)
                    let ca = ((comeBackProteinFoodItem.food!.carbohydrates) * comeBackProteinFoodItem.numberServing)
                    let pr = ((comeBackProteinFoodItem.food!.proteins) * comeBackProteinFoodItem.numberServing)
                    let fa = ((comeBackProteinFoodItem.food!.fats) * comeBackProteinFoodItem.numberServing)
                    
                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                    //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket


                   
                    
                    
                case Constants.CARBOHYDRATES:
                    deficient = macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!

                    
                    //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    
                    var comeBackCarbFoodItem = FoodItem()
                    var food :Food = Food()

                    if deficient < Constants.maximumNumberOfGramsToIgnore {
                        break breakLabel
                    }
                    else if deficient < 20{
                        for fo in extraCarbTreats{
                            if foodsAlreadySelected.contains(fo) == false && fo.alwaysEatenWithOneOf.count == 0{
                                food = fo
                                break
                            }
                        }
                    } else {
                        for fo in extraCarbTreats.reverse(){
                            if foodsAlreadySelected.contains(fo) == false && fo.alwaysEatenWithOneOf.count == 0{
                                food = fo
                                break
                            }
                        }
                    
                    }
                    
                    
                    if food.name == ""{
                        
                        let randomInt = Int(arc4random_uniform(UInt32(extraCarbTreats.count)))
                        food = extraCarbTreats[randomInt]
                    }
                    comeBackCarbFoodItem.food = food
                    comeBackCarbFoodItem.numberServing = (deficient/(food.carbohydrates))
                    
                    let overflow = createOverFlowStructure(numberOfMealsRemaining, macrosAllocatedToday: macrosAllocatedToday, macrosDesiredToday: macrosDesiredToday)
                    
                    let fi = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow([food], attribute: macro, desiredQuantity: deficient, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday)
                    
                    if fi.count > 0 {
                        comeBackCarbFoodItem = fi.first!
                    }
                    
                    /*
                    if (food.servingSize?.name != Constants.grams) && (food.servingSize?.name != Constants.ml) {
                        //round up to the closet whole number as we can only have 1 egg, or 2 pots etc
                        if comeBackCarbFoodItem.numberServing > 0 && comeBackCarbFoodItem.numberServing < 1  {
                            comeBackCarbFoodItem.numberServing = ceil(deficient/(food.carbohydrates))
                        }
                        else {
                            comeBackCarbFoodItem.numberServing = floor(deficient/(food.carbohydrates))
                        }
                    }
 */
                    
                    
                    dailyMealPlan = assignMealTo(Constants.CARBOHYDRATES, foodItem: comeBackCarbFoodItem, plan: dailyMealPlan)
                    
                    let ka = ((comeBackCarbFoodItem.food!.calories) * comeBackCarbFoodItem.numberServing)
                    let ca = ((comeBackCarbFoodItem.food!.carbohydrates) * comeBackCarbFoodItem.numberServing)
                    let pr = ((comeBackCarbFoodItem.food!.proteins) * comeBackCarbFoodItem.numberServing)
                    let fa = ((comeBackCarbFoodItem.food!.fats) * comeBackCarbFoodItem.numberServing)
                    
                    
                    
                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                    
                    
                case Constants.FATS:
                    deficient = macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!
                    let fPredicate : NSCompoundPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates:[highFatPredicate, /*foodsAlreadySelected*/])
                    let extraFatFoods = realm.objects(Food).filter(fPredicate).sorted(Constants.FATS.lowercaseString, ascending: true)
                    //TODO: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    
                        
                    var comeBackFattyFoodItem = FoodItem()
                    var food :Food = Food()
                    
                    guard deficient > 0  else {
                        break breakLabel
                    }
                    if deficient < Constants.maximumNumberOfGramsToIgnore {
                        break breakLabel
                    }
                    else if deficient < 20{
                        for fo in extraFatFoods{
                            if foodsAlreadySelected.contains(fo) == false && fo.alwaysEatenWithOneOf.count == 0{
                                food = fo //TODO - THIS IS NOT A RANDOM SELECTION
                                break
                            }
                        }
                    } else {
                        for fo in extraFatFoods.reverse(){
                            if foodsAlreadySelected.contains(fo) == false && fo.alwaysEatenWithOneOf.count == 0{
                                food = fo //TO - THIS IS NOT A RANDOM SELECTION
                                break
                            }
                        }
                    }
                    
                    if food.name == ""{
                        let randomInt = Int(arc4random_uniform(UInt32(extraFatFoods.count)))
                        food = extraFatFoods[randomInt]
                    }
                    
                    comeBackFattyFoodItem.food = food
                    comeBackFattyFoodItem.numberServing = (deficient/(food.fats))
                    
                    let overflow = createOverFlowStructure(numberOfMealsRemaining, macrosAllocatedToday: macrosAllocatedToday, macrosDesiredToday: macrosDesiredToday)
                    
                    let fi = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow([food], attribute: macro, desiredQuantity: deficient, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday)
                    
                    if fi.count > 0 {
                        comeBackFattyFoodItem = fi.first!
                    }
                    
                    /*
                    if (food.servingSize?.name != Constants.grams) && (food.servingSize?.name != Constants.ml) {
                        //round up to the closet whole number as we can only have 1 egg, or 2 pots etc
                        if comeBackFattyFoodItem.numberServing > 0 && comeBackFattyFoodItem.numberServing < 1  {
                            comeBackFattyFoodItem.numberServing = ceil(deficient/(food.carbohydrates))
                        }
                        else {
                            comeBackFattyFoodItem.numberServing = floor(deficient/(food.carbohydrates))
                        }
                    }
                     */
                    
                    dailyMealPlan = assignMealTo(Constants.FATS, foodItem: comeBackFattyFoodItem, plan: dailyMealPlan)
                    
                    //dailyMealPlan.meals.sorted("proteins", ascending: false)
                    
                    
                    let ka = ((comeBackFattyFoodItem.food!.calories) * comeBackFattyFoodItem.numberServing)
                    let ca = ((comeBackFattyFoodItem.food!.carbohydrates) * comeBackFattyFoodItem.numberServing)
                    let pr = ((comeBackFattyFoodItem.food!.proteins) * comeBackFattyFoodItem.numberServing)
                    let fa = ((comeBackFattyFoodItem.food!.fats) * comeBackFattyFoodItem.numberServing)

                    
                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                    
                case Constants.vegetableFoodType:
                    break
                    
                default:
                    break
                }
            }
            
                
                
            //TODO: Ensure that proteins has -10 by the time I get to the first pass of proteing in meal 4
            
            print("DailyMeal Plan:\nCalories: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
            
            // - PackageFoodsNicely - at the end - ensure no duplicates in meal, ensure ordering is nice
            
            /*
            for meal in dailyMealPlan.meals {
                var arrayIndiciesToDelete = [Int]()
                for (index, fooditem) in meal.foodItems.enumerate(){
                    for (index2, fi2) in meal.foodItems.enumerate(){
                        if fi2.food?.name == fooditem.food?.name && (fi2.isEqual(fooditem) == false) {
                            meal.foodItems[index].numberServing = fooditem.numberServing + fi2.numberServing
                            arrayIndiciesToDelete.append(index2)
                        }
                    }
                }
                for index in arrayIndiciesToDelete{
                    meal.foodItems.removeAtIndex(index)
                }
                
            }
            */
            

            
            plans.append(dailyMealPlan)
            
            
            for foodArray in dailyMealPlan.meals{
                for foodItem in foodArray.foodItems{
                    csv3 += (foodItem.food?.name)! + ","
                }
                
            }
            csv3 += "\n"
            
        }
        
        let fileManager = NSFileManager()
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        
        if urls.count > 0 {
            let documentsFolder = urls[0]
            print("\(documentsFolder)")
        } else {
            print("could not find the documents folder")
        }
        
        
        
        for csv in [csv1]{
            let destinationPath = NSTemporaryDirectory() + "testfly \(NSDate().timeIntervalSince1970*1000).csv"
            try! csv.writeToFile(destinationPath, atomically: true, encoding: NSUTF8StringEncoding)
                /*
                file?.writeData(csv.dataUsingEncoding(NSUTF8StringEncoding)!) // Set the data we want to write, write it to the file
                file?.closeFile() // Close the file
 */
                }
        
        
        
        
        return plans
        }
    
    
    
    static func foodSortByServingType(f1: Food, _ f2: Food) -> Bool {
        let order = Constants.SERVING_SIZE_ORDER
        return order.indexOf((f1.servingSize?.name)!)! < order.indexOf((f2.servingSize?.name)!)!
    }
    
    
    static func mealSortByProteins(m1: Meal, _ m2: Meal) -> Bool {
        return m1.totalProteins() < m2.totalProteins()
    }
    
    static func mealSortByCarbs(m1: Meal, _ m2: Meal) -> Bool {
        return m1.totalCarbohydrates() < m2.totalCarbohydrates()
    }
    
    static func mealSortByFats(m1: Meal, _ m2: Meal) -> Bool {
        return m1.totalFats() < m2.totalFats()
    }
    
    
    
    
    static func assignMealTo(macro:String, foodItem:FoodItem, plan:DailyMealPlan) ->DailyMealPlan{
    
        assert([Constants.PROTEINS, Constants.CARBOHYDRATES, Constants.FATS].containsObject(macro), "INVALID MACRO USED")
        /*
        switch macro {
        case Constants.PROTEINS:
            Array(plan.meals).sort(mealSortByProteins).first?.appendOrCombine(foodItem)
        case Constants.CARBOHYDRATES:
            Array(plan.meals).sort(mealSortByCarbs).first?.appendOrCombine(foodItem)
        case Constants.FATS:
            Array(plan.meals).sort(mealSortByFats).first?.appendOrCombine(foodItem)
        default:
            break
        }
        */
        
        var lowestMeal = plan.meals[0]
        
        for meal in plan.meals{
            switch macro {
            case Constants.PROTEINS:
                if meal.totalProteins() < lowestMeal.totalProteins(){
                    lowestMeal = meal
                }
            case Constants.CARBOHYDRATES:
                if meal.totalCarbohydrates() < lowestMeal.totalCarbohydrates(){
                    lowestMeal = meal
                }
            case Constants.FATS:
                if meal.totalFats() < lowestMeal.totalFats(){
                    lowestMeal = meal
                }
            default: break
                
            }
            
        }
        for meal in plan.meals{
            if meal.isEqual(lowestMeal){
                meal.foodItems.append(foodItem)
                print("Assigning: \(foodItem.food?.name), for \(macro), to meal number \(meal.name)")
            }
        }

        
        return plan
    
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
    
    
    
    
    static func constrainPortionSizeBasedOnFood(fooditem:FoodItem) ->(FoodItem){
        // ensure that the fooditem returned contains a sensible serving size.
        
        print("Started with: \(fooditem.numberServing) of \(fooditem.food?.name)")
        let realm = try! Realm()
        let condiment = realm.objects(FoodType).filter("name contains 'Condiment'")
        
        if Constants.isFat.evaluateWithObject(fooditem.food){
            fooditem.numberServing = 0.1 //10g or 10ml of fat
            return fooditem
        }
        
        switch (fooditem.food?.servingSize?.name)! {
            case Constants.pot:
                break
            case Constants.cup:
                if fooditem.numberServing > 1{
                    fooditem.numberServing = 1
                }
            case Constants.ml:
                
                if fooditem.numberServing > 5{
                    fooditem.numberServing = 5
                }
            case Constants.grams:
                if fooditem.numberServing > 3{
                    fooditem.numberServing = 3
            }
            case Constants.slice:
                if fooditem.numberServing > 4{
                    fooditem.numberServing = 4
                }
            case Constants.item:
                if fooditem.numberServing > 5{
                    fooditem.numberServing = 5
                }
            case Constants.tablet:
                if fooditem.numberServing > 3{
                    fooditem.numberServing = 3
                }
            case Constants.heaped_teaspoon:
                if fooditem.numberServing > 4{
                    fooditem.numberServing = 4
                }
            case Constants.pinch:
                if fooditem.numberServing > 6{
                    fooditem.numberServing = 6
                }
            default:
                break
            }
            
            if condiment.count > 0{
                if ((fooditem.food?.foodType.contains(condiment.first!)) != nil){
                    if fooditem.numberServing > 0.25{
                        fooditem.numberServing = 0.25
                        // if it's greater than 25g or 25ml then turn it down and make it 25.
                    }
                }
            }
            
        print("Exiting with: \(fooditem.numberServing)")
        return fooditem
        
    }
    
        /*

     if a condiment then no more than 25g,
     if slices then no more than 4,
     if it's ml then no more than 500ml unless it's water,
     if it's a heaped teaspoon no more than 4
     
 
    */
    
    

    /**
    This function takes a given food and returns a fooditem with the given amount of a macro. For example Bread, fat:20g will return a fooditem that contains enough bread to give 20g of fat.
    
    
    - parameter food: A food object.
    - parameter attribute: 'carbs', 'proteins', or 'fats'.
    - parameter desiredQuantity: ...
     
    
    
    */
    static func apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foods:[Food], attribute:String, desiredQuantity:Double, overflowAmounts:[Double], macrosAllocatedToday:[String:Double])->[FoodItem]
    {
        
        
        var overflow = overflowAmounts
        
        var foodItems : [FoodItem] = []
        // Need to update the overflowAmounts variable if there are more than one foods
        
        
        foodloop: for food in foods {
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
            
            var fooditem = FoodItem()
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
                
                print("Overflow 0: \(overflow[0])")
                print("Overflow 1: \(overflow[1])")
                print("Overflow 2: \(overflow[2])")
                //Only scale if the macrolimit isnt a silly number like less than 3g as this could make the amount scaled down to really small. As extra safety, consider ensuring that the numberserving is no less than 0.05
                
                //if any of the macros are too small then don't even bother starting the iteration
                /*
                for amount in overflow{
                    if amount < 3{
                        print("SKIPPING as the \(Constants.MACRONUTRIENTS[index]) for \(food.name) is too small to scale at \(macroLimit).")
                        break foodloop
                    }
                }
                */
                if Constants.MACRONUTRIENTS[index] == Constants.PROTEINS {
                    while (fooditem.numberServing * macroAmount)  > (Double(macroLimit) - 10) {
                        //we need to scale this down!
                        fooditem.numberServing = (fooditem.numberServing - 0.01)
                    }
                } else {
                    while (fooditem.numberServing * macroAmount)  > Double(macroLimit) {
                        //we need to scale this down!
                        //print("\nGUARDING AGAINST EXCESS: \(Constants.MACRONUTRIENTS[index])\n")
                        fooditem.numberServing = (fooditem.numberServing - 0.01)
                        if fooditem.numberServing < 0 {
                            print("\(fooditem.food?.name) has a serving size below 0. The macro is: \(Constants.MACRONUTRIENTS[index]) of \(macroAmount) and the macroLimit is: \(macroLimit) \n")
                        }
                    }
                } // END of else
            } // END OF ENUMERATE
            
            print("If skipping, then this shouldn't be called")
            if fooditem.numberServing <= 0 {
                print("WARNING : THIS SERVING SIZE IS NEGATIVE ! !")
                fooditem.numberServing = 0
            }
            
            
            if (food.servingSize?.name != Constants.grams) && (food.servingSize?.name != Constants.ml) {
                //round up to the closet whole number as we can only have 1 egg, or 2 pots etc
                if fooditem.numberServing > 0 && fooditem.numberServing < 1  {
                    fooditem.numberServing = ceil(desiredQuantity/foodAttributeAmount)
                }
                else {
                    fooditem.numberServing = floor(desiredQuantity/foodAttributeAmount)
                }
            }
            
            //fooditem = constrainPortionSizeBasedOnFood(fooditem)
            //DataHandler.createFoodItem(fooditem)
            print("Just added: \(fooditem.food?.name)")
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
        return foodItems
    }
    
    
    

    


}







