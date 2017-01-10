import Foundation
import RealmSwift

class MealPlanAlgorithm : NSObject{
    
    
    static func createOverFlowStructure(_ numberOfMealsRemaining:Int,macrosAllocatedToday:[String:Double], macrosDesiredToday:[String:Double]) -> [Double]{
        var overflow = [Double]() // You get this overflow limit for each meal, and its fixed, not for each food group.
        
        let overflowP : Double
        let overflowC : Double
        let overflowF : Double
        
        var remainingMeals = 0
        
        if numberOfMealsRemaining == 0{
            remainingMeals = 1
        }
        
        overflowP = ((macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!)/Double(remainingMeals))
        overflowC = ((macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!)/Double(remainingMeals))
        overflowF = ((macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!)/Double(remainingMeals))
        
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
    static func createMeal(_ day:Int,countValue:Int)->Meal{
        
        
        let meal1 = Meal()
        
        meal1.name = "Meal " +  day.description
        
        meal1.foodItems.append(DataHandler.createFoodItem(DataHandler.getFoodRandam(1 % (day*countValue) + 1)! ,numberServing: 1.0));
        meal1.foodItems.append(DataHandler.createFoodItem(DataHandler.getFoodRandam(2 % (day*countValue) + 1)! ,numberServing: 1));
        meal1.foodItems.append(DataHandler.createFoodItem(DataHandler.getFoodRandam(3 % (day*countValue) + 1)! ,numberServing: 1));
        DataHandler.createMeal(meal1);
        return meal1;
        
    }
    
    //AIM < 400 lines of code
    
    /**
     This function assumes .
     
     
     - parameter foods: A List of Foods in the database that don't have 'oftenEatenWith' or 'alwaysEatenWithOneOf' yet.
     - parameter json: NSArray of foods and their attributes including.
     
     
     */
    static func createMealPlans(_ thisWeek:Week) -> [DailyMealPlan]{
        
        
        var csv1 : String = ""
        var csv2 : String = ""
        var csv3 : String = ""
        
        var plans : [DailyMealPlan] = []
        DataHandler.updateServingSizes()
        
        let realm = try! Realm()
        

        //let likedFoods = DataHandler.getLikeFoods() //TODO: SHOW USERS FOODS THAT HE LIKES
        let dislikedFoods = DataHandler.getNamesOfDisLikedFoods()
        let onlyBreakfastFoods = DataHandler.getBreakfastOnlyFoods()
        

        
        
        let macros = thisWeek.macroAllocation
        let kcal = Double(thisWeek.calorieAllowance)
        let bio = DataHandler.getActiveBiographical()
        let dietRequirements = bio.dietaryRequirement
        let desiredNumberOfDailyMeals = Double(bio.numberOfDailyMeals)
        
        //Predicates
        var listOfAndPredicates : [NSPredicate] = []
        let lowCarbPredicate = NSPredicate(format: "carbohydrates <= 5")
        let highCarbPredicate = NSPredicate(format: "carbohydrates > 15 AND fats < 9") //Used to search only the foods associated with the choosen protein source
        let lowFatPredicate = NSPredicate(format: "fats < 5")
        
        let highFatPredicate = NSPredicate(format: "fats BETWEEN {15, 40} AND carbohydrates BETWEEN {2,10}")
        let superHighFatPredicate = NSPredicate(format: "fats BETWEEN {40, 75} AND carbohydrates BETWEEN {2,5}")
        let carbTreatPredicate = NSPredicate(format: "carbohydrates BETWEEN {8, 95} AND fats BETWEEN {0, 5}") // Used to search across all foods in db
        let vegetablePredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.vegetableFoodType)
        let denseProteinPredicate = NSPredicate(format: "(proteins > 20) AND (fats < 4) AND (carbohydrates < 7)")
        let highProteinPredicate = NSPredicate(format: "(proteins > 17) AND (fats < 7) AND (carbohydrates < 7)")
        let lightProteinTreat = NSPredicate(format: "(proteins BETWEEN {7, 20}) AND (fats < 8) AND (carbohydrates < 8)")
        let notOnlyBreakfastPredicate = NSPredicate(format: "NONE SELF.foodType.name == [c] %@", onlyBreakfastFoods)
        let notCondiment = NSPredicate(format: "NONE SELF.foodType.name == [c] %@", Constants.condimentFoodType)
        let readyToEatPredicate = NSPredicate(format: "readyToEat == %@", NSNumber(value: true as Bool))
        //http://stackoverflow.com/questions/6169121/how-to-write-a-bool-predicate-in-core-data
        let vegetarianPredicate = NSPredicate(format: "ANY SELF.dietSuitability.name == [c] %@", Constants.vegetarian)
        
        //let dietaryRequirementPredicate = NSPredicate(format: "ANY SELF.dietSuitability IN [c] %@", dietRequirements)
        
        /*
        let noPretFood = NSPredicate(format: "NOT name CONTAINS[c] 'PRET'")
        let pureFatsPredicate = NSPredicate(format: "(proteins < 5) AND (fats > 20) AND (carbohydrates < 5)")
        let pureCarbsPredicate = NSPredicate(format: "(proteins < 2) AND (fats < 2) AND (carbohydrates >= 10)")
        let drinkPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.drinkFoodType)
        let dietaryNeedPredicate = NSPredicate(format: "self.dietSuitability.name == %@", dietaryNeed!)
        
        let likedFoodsPredicate = NSPredicate(format: "self.name in %@", likedFoods)
        */
        let dislikedFoodsPredicate = NSPredicate(format: "NOT SELF.name IN %@", dislikedFoods)
 
        

        let eatenAtBreakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.eatenAtBreakfastFoodType)
        
        
 
         
        
        
        let mediumBreakfastProteinPredicate = NSPredicate(format: "(proteins >= 8) AND (fats <= 6) OR (proteins >= 21) AND (fats <= 21) OR (proteins >= 24) AND (fats <= 18)")
        
        
        //Indices
        let proteinIndex = Constants.MACRONUTRIENTS.index(of: Constants.PROTEINS)!
        let carbIndex = Constants.MACRONUTRIENTS.index(of: Constants.CARBOHYDRATES)!
        let fatIndex = Constants.MACRONUTRIENTS.index(of: Constants.FATS)!
        let vegIndex = Constants.MACRONUTRIENTS.index(of: Constants.vegetableFoodType)!
        
        
        
        
        if desiredNumberOfDailyMeals > 5 {
            //return
        }
        
        // Create the desiredNumberOfDailyMeals for 7 days
        // Put this week into a Week object.
        // Do the same for next week.
        
        
        // CREATE PREDICATES
        let compoundPredForCarbs = NSCompoundPredicate(andPredicateWithSubpredicates: [carbTreatPredicate, dislikedFoodsPredicate, notCondiment,  /* notOnlyBreakfastPredicate, readyToEatPredicate, dietaryRequirementPredicate*/])
        
        let compoundPredForProteins = NSCompoundPredicate(andPredicateWithSubpredicates: [lightProteinTreat, dislikedFoodsPredicate, vegetarianPredicate, notCondiment]) /*notOnlyBreakfastPredicate, dietaryRequirementPredicate*/
        
        let compoundPredForHeavyProteins = NSCompoundPredicate(andPredicateWithSubpredicates: [highProteinPredicate, dislikedFoodsPredicate, notCondiment /*notOnlyBreakfastPredicate, dietaryRequirementPredicate*/])
        
        let extraCarbTreats = realm.objects(Food.self).filter(compoundPredForCarbs)
        var lightProteins = realm.objects(Food.self).filter(compoundPredForProteins)
        let highProteins = realm.objects(Food.self).filter(compoundPredForHeavyProteins).sorted(byProperty: Constants.PROTEINS.lowercased(), ascending: true)
        
            
        for dayIndex in 1...7 {
            var dailyMealPlan = DailyMealPlan()
            dailyMealPlan.dayId = dayIndex
            var numberOfMealsRemaining = Int(desiredNumberOfDailyMeals)
            
            
            //divide kcal required by number of meals, each one should not be +-20% of this
            let macrosDesiredToday : [String:Double] = [Constants.CALORIES:kcal,
                                                        Constants.CARBOHYDRATES:macros[carbIndex].value,
                                                        Constants.PROTEINS:macros[proteinIndex].value, 
                                                        Constants.FATS:macros[fatIndex].value/*Int(macros[2].value)*/]
            var macrosAllocatedToday = [Constants.CALORIES:0.0, Constants.CARBOHYDRATES:0.0, Constants.PROTEINS:0.0, Constants.FATS:0.0]
            
            
            for mealIndex in 1...Int(desiredNumberOfDailyMeals){
                #if debug
                print("Day \(dayIndex), meal \(mealIndex)")
                #endif
                //var foodBasket :[String :[Food]] = [Constants.PROTEINS:[], Constants.CARBOHYDRATES:[],Constants.FATS:[], Constants.vegetableFoodType:[]]
                var foodBasket : [[Food]] = [ [], [], [], [] ]
                var sortedFoodBasket : [[Food]] = []
                var sortedFoodItemBasket : [[FoodItem]] = [ [], [], [], [] ]
                
                listOfAndPredicates = []
                listOfAndPredicates.append(contentsOf: [/*dietaryRequirementPredicate,*/ dislikedFoodsPredicate, notCondiment, highProteinPredicate])
                
                if mealIndex == 1{
                    _ = listOfAndPredicates.popLast()
                    listOfAndPredicates.append(contentsOf: [mediumBreakfastProteinPredicate, eatenAtBreakfastPredicate])
                } else{
                    //listOfAndPredicates.append(notOnlyBreakfastPredicate)
                }
                
                if mealIndex == Int(desiredNumberOfDailyMeals){
                    listOfAndPredicates.append(lowFatPredicate)
                }
                
                let newAndCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfAndPredicates)
                //let newOrCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfORPredicates)
                
                
                let foodResults = realm.objects(Food.self).filter(newAndCompoundPredicate)//.filter(newOrCompoundPredicate)
                var randomNumber : UInt32 = arc4random_uniform(UInt32(foodResults.count))
                
                guard foodResults.count > 0 else {
                    break
                }
                let p = foodResults[Int(randomNumber)]
                foodBasket[proteinIndex].append(p)
                if p.alwaysEatenWithOneOf.count > 0{
                    let aCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate /*,dietaryRequirementPredicate*/])
                    let options = p.alwaysEatenWithOneOf.filter(aCompoundPredicate)
                    randomNumber = arc4random_uniform(UInt32(options.count))
                    //TODO: Place this AEWOO in the right basket
                    
                    
                    if randomNumber > 0 {
                        //TODO: CHECK with delegate method before selection.
                        options[Int(randomNumber)].doNotReduceToZero = true
                        foodBasket[carbIndex].append(options[Int(randomNumber)])
                    }
                    
                }
                
                //Get a number of light protein snacks throughout the day
                
                var random_yay_nay = 1// Int(arc4random_uniform(3)) //if 0 t1hen lets get a second food, else move on and just use one.
                if random_yay_nay == 0 {
                    // ensure we don't select the same item
                    
                    var newRandNum = arc4random_uniform(UInt32(lightProteins.count))
                    if lightProteins.count == 0{
                        lightProteins = foodResults
                    }
                    newRandNum = arc4random_uniform(UInt32(lightProteins.count))
                    let newFood = lightProteins[Int(newRandNum)]
                    
                    if foodBasket[proteinIndex].contains(newFood) == false {
                        foodBasket[proteinIndex].append(newFood)
                        if newFood.alwaysEatenWithOneOf.count > 0{
                            newRandNum = arc4random_uniform(UInt32(newFood.alwaysEatenWithOneOf.count))
                            let selectedFood = newFood.alwaysEatenWithOneOf[Int(newRandNum)]
                            selectedFood.doNotReduceToZero = true
                            
                            
                            //TO-DO - Use food.macro instead of the code below
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
                var carbPredicateList = [/*dietaryRequirementPredicate*/ dislikedFoodsPredicate, highCarbPredicate, notCondiment]
                if mealIndex == 1{
                    carbPredicateList.append(eatenAtBreakfastPredicate)
                }
                var carbOptions = realm.objects(Food.self).filter(NSCompoundPredicate(andPredicateWithSubpredicates: carbPredicateList))
                let OEWcarbOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: carbPredicateList))
                //&& (carbsApportionatedSoFar <= Double(carbsRequiredSoFar))
                if (carbsNeededToday > 0) && (carbOptions.count > 0) {
                    if OEWcarbOptions.count > 0{
                        carbOptions = OEWcarbOptions
                    }

                    randomNumber = arc4random_uniform(UInt32(carbOptions.count))
                    let foodSelected = carbOptions[Int(randomNumber)]
                    
                    
                    foodBasket[carbIndex].insert(foodSelected, at: 0)// if this is a condiment or something difficult to divide then we want to handle that first in the allocation process below.
                    
                    foodSelectedBreak: if foodSelected.alwaysEatenWithOneOf.count > 0{
                        randomNumber = arc4random_uniform(UInt32(foodSelected.alwaysEatenWithOneOf.count))
                        let selectedFood = foodSelected.alwaysEatenWithOneOf[Int(randomNumber)]
                        selectedFood.doNotReduceToZero = true
                        
                        if selectedFood.foodType.contains(DataHandler.getFoodType(Constants.vegetableFoodType)){
                            foodBasket[vegIndex].append(selectedFood)
                            break foodSelectedBreak
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
            
                
                random_yay_nay = 1 // this controls the second carb food
                //random_yay_nay = Int(arc4random_uniform(3)) //if 0 t1hen lets get a second food, else move on and just use one.
                if random_yay_nay == 0 && extraCarbTreats.count > 0 {
                    
                    var newRandNum = arc4random_uniform(UInt32(extraCarbTreats.count))
                    let newFood = extraCarbTreats[Int(newRandNum)]
                    
                    if foodBasket[proteinIndex].contains(newFood) == false {
                        foodBasket[carbIndex].append(newFood)
                        
                        if newFood.alwaysEatenWithOneOf.count > 0{
                            newRandNum = arc4random_uniform(UInt32(newFood.alwaysEatenWithOneOf.count))
                            let selectedFood = newFood.alwaysEatenWithOneOf[Int(newRandNum)]
                            selectedFood.doNotReduceToZero = true
                            
                            if selectedFood.foodType.contains(DataHandler.getFoodType(Constants.vegetableFoodType)){
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
                
            
            
                
                
                
                
                
                

                
                //fats if required FOR THIS MEAL!
                var fatPredicateList = [/*dietaryRequirementPredicate,*/ dislikedFoodsPredicate, highFatPredicate]
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
                var fatOptions = realm.objects(Food.self).filter(NSCompoundPredicate(andPredicateWithSubpredicates: fatPredicateList))
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
                        selectedFood.doNotReduceToZero = true
                        
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
                    var vegetableOptions = realm.objects(Food.self).filter(NSCompoundPredicate(andPredicateWithSubpredicates: [/*dietaryRequirementPredicate,*/ dislikedFoodsPredicate, vegetablePredicate, lowCarbPredicate]))
                    let OEWvegetableOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [/*dietaryRequirementPredicate,*/ dislikedFoodsPredicate, vegetablePredicate, lowCarbPredicate]))
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
                
                
                
                //MARK TODO: REFACTOR. We can ensure that the below is only used for debugging. Sorting should come at the end.
                
                for foodArray in foodBasket{
                    foodArrayEmpty: if foodArray.isEmpty{
                        sortedFoodBasket.append([])// if any food group is empty then fill it with an empty as loop below depends on there being 4 in the order of constants.MACRONUTRIENTS
                        break foodArrayEmpty
                    } else {
                        
                        for food in foodArray{
                            csv1 += food.name + ","
                        }
                        
                        sortedFoodBasket.append(foodArray.sorted(by: foodSortByServingType))
                    }
                }
                csv1 += "\n"
                
                sortedFoodBasket = [sortedFoodBasket[1], sortedFoodBasket[0], sortedFoodBasket[2], sortedFoodBasket[3]] //[[Food]]
                
                
                
                // You get this overflow limit for each meal, and its fixed, not for each food group.
                let eatNoMoreThanP = (macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!) / Double(numberOfMealsRemaining)
                
                let eatNoMoreThanC = (macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!) / Double(numberOfMealsRemaining)
                
                let eatNoMoreThanF = (macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!) / Double(numberOfMealsRemaining)
                
                let eatNoMoreThan = [eatNoMoreThanP, eatNoMoreThanC, eatNoMoreThanF]
                
                var leftOverForThisMeal = [eatNoMoreThan[0], eatNoMoreThan[1], eatNoMoreThan[2]]
                
                
                
                //divide kcal required by number of meals, each one should not be +-20% of this
                var loop = 0
                for (index,foodArray) in sortedFoodBasket.enumerated(){
                    
                    //let key = Constants.MACRONUTRIENTS[loop]
                    let key  = Constants.SPECIAL_MACRONUTRIENTS[loop]
                    

                    
                    if (foodArray.count > 0) && (key != Constants.vegetableFoodType) {
                        //Get the remaining amount left for today, for this macronutrient, and divide it amongst the remaining number of meals for today
                        let desiredToday = Double((macrosDesiredToday[key]!))
                        let allocatedtoday = Double((macrosAllocatedToday[key]!))
                        let desiredAmount = (desiredToday - allocatedtoday) / Double(numberOfMealsRemaining)
                        
                        
                        // Not negative and not tiny amounts
                        if desiredToday > 1 && leftOverForThisMeal[0] > -5 && leftOverForThisMeal[1] > -5 && leftOverForThisMeal[2] > -5{
                            //TO-DO: Consider a parameter for the split bewteen two proteins/carbs etc
                            let results = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foodArray, attribute: key, desiredQuantity: desiredAmount, overflowAmounts: leftOverForThisMeal, macrosAllocatedToday: macrosAllocatedToday, lastMealFlag: false, beforeComeBackFlag: true, dietaryRequirements: dietRequirements)
                            sortedFoodItemBasket.append(results)
                            
                            for fi in results{
                                let ka = (fi.food?.calories)! * fi.numberServing
                                let ca = (fi.food?.carbohydrates)! * fi.numberServing
                                let pr = (fi.food?.proteins)! * fi.numberServing
                                let fa = (fi.food?.fats)! * fi.numberServing
                                
                                leftOverForThisMeal[0] = (leftOverForThisMeal[0] - pr)
                                leftOverForThisMeal[1] = (leftOverForThisMeal[1] - ca)
                                leftOverForThisMeal[2] = (leftOverForThisMeal[2] - fa)
                                
                                macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                                macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                                macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                                macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                            }
                        }
                        
                        

                        
                        
                        
                    }
                    if key == Constants.vegetableFoodType{
                        let desiredAmount = eatNoMoreThanC * Constants.vegetablesAsPercentageOfCarbs
                        
                        if desiredAmount > 5 {
                            let results = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foodArray, attribute: key, desiredQuantity: desiredAmount, overflowAmounts: leftOverForThisMeal, macrosAllocatedToday: macrosAllocatedToday, lastMealFlag: false, beforeComeBackFlag: true, dietaryRequirements: dietRequirements)
                            sortedFoodItemBasket.append(results)
                            
                            for fooditem in results{
                                
                                let ka = (fooditem.food?.calories)! * fooditem.numberServing
                                let ca = (fooditem.food?.carbohydrates)! * fooditem.numberServing
                                let pr = (fooditem.food?.proteins)! * fooditem.numberServing
                                let fa = (fooditem.food?.fats)! * fooditem.numberServing
                                
                                leftOverForThisMeal[0] = (leftOverForThisMeal[0] - pr)
                                leftOverForThisMeal[1] = (leftOverForThisMeal[1] - ca)
                                leftOverForThisMeal[2] = (leftOverForThisMeal[2] - fa)
                                
                                macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                                macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                                macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                                macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                            }
                            
                            
                        }
 
                        
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
                
                let calender = Calendar.current

                let mealplanDate = (calender as NSCalendar).date(byAdding: .day, value: dayIndex, to: calender.startOfDay(for: thisWeek.start_date), options: [.matchFirst])
                
                meal.date = mealplanDate!
                
                var count = 0
                for foodArray in sortedFoodItemBasket{
                    
                    
                    for foodItem in foodArray{
                        
                        foodItem.numberServing = Constants.roundToPlaces(foodItem.numberServing, decimalPlaces: 2) // rounding for customer use
                        #if debug
                        print("\(count):  \(foodItem.food!.name.capitalized), \n Serving size: \(foodItem.numberServing) \n Proteins: \(foodItem.food!.proteins*foodItem.numberServing), \n carbs: \(foodItem.food!.carbohydrates*foodItem.numberServing), \n fats: \(foodItem.food!.fats*foodItem.numberServing) \n kcal : \(foodItem.getTotalCal()) \n\n")
                        #endif
                    }
                    
                    count = count+1
                    
                    //meal.appendOrCombineFoodItems(foodArray)
                    meal.foodItems.append(objectsIn: foodArray)
                    
                    
                }
                //TODO: FIX THIS DATE
                meal.date = (Calendar.current as NSCalendar).date(byAdding: .day,value: Constants.DAYS_SINCE_START_OF_THIS_WEEK,to: Constants.START_OF_WEEK as Date, options: [])!
                
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
            #if debug
            print("Before the comeback we've fufilled:\nCalories: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
            #endif
            
            
            
            // THE COMEBACK!
            var foodsAlreadySelected :[String] = [] //TO-DO: Create  flag that turns this on. The user may or may not want new foods added to their meal plan.
            for each in dailyMealPlan.foodNames(){
                foodsAlreadySelected.append(each)
            }

            
            thecomebackBreak: for macro in Constants.SPECIAL_MACRONUTRIENTS {
                
                guard macro != Constants.vegetableFoodType else {
                    break
                }
                deficient = macrosDesiredToday[macro]! - macrosAllocatedToday[macro]!
                let allFoodCompoundPred = NSCompoundPredicate(andPredicateWithSubpredicates: [/*dietaryRequirementPredicate,*/ dislikedFoodsPredicate, notCondiment])
                
                let allFoods = realm.objects(Food.self).filter(allFoodCompoundPred).sorted(byProperty: macro.lowercased(), ascending: true)
                var array = [Food]()
                for f in allFoods{
                    array.append(f)
                }
                
                var overflow = [macrosDesiredToday[Constants.PROTEINS]! - dailyMealPlan.totalProteins(), 
                                macrosDesiredToday[Constants.CARBOHYDRATES]! - dailyMealPlan.totalCarbohydrates(),
                                macrosDesiredToday[Constants.FATS]! - dailyMealPlan.totalFats()]
                //var overflow = createOverFlowStructure(numberOfMealsRemaining, macrosAllocatedToday: macrosAllocatedToday, macrosDesiredToday: macrosDesiredToday)
                
                /* This dynamic predicate finds all foods that have a nutritional profile that matches the protein, carbs, and fat requirements at this point in the process +-20%.
                 
                    An overflow of 0.1 is given for 0 values to ensure that division can take place below.
                 
                    Relationships are expressed between:
                    carbs->fats
                    proteins->fats
                    protein->carbs
                    Relationships expressed one way are sufficient to cover the other way.
                 
                    Each line is looking for a macro >= another macro expressed as a ratio to itself (as a quotient).
                    For every gram of carbs, how many grams of fat do I want etc.
                    
                    TODO: Consider modulo. Currently the predicate below will ignore foods that are precisely double or triple food.carbs or food.proteins. If we had those we could simply divide the serving by two or three.
 
 
                */
                let dynamicPredicate = NSPredicate {
                    (evaluatedObject, _) in
                    let food = (evaluatedObject as! Food)
                    if overflow[0] == 0{
                        overflow[0] = 0.1
                    }
                    if overflow[1] == 0{
                        overflow[1] = 0.1
                    }
                    if overflow[2] == 0{
                        overflow[2] = 0.1
                    }
                    return (
                            food.carbohydrates >= food.fats*(overflow[1]/overflow[2])*0.95  &&
                            food.carbohydrates <= food.fats*(overflow[1]/overflow[2])*1.05 &&
                            
                            food.proteins >= food.fats*(overflow[0]/overflow[2])*0.95 &&
                            food.proteins <= food.fats*(overflow[0]/overflow[2])*1.05 &&
                        
                            food.proteins >= food.carbohydrates*(overflow[0]/overflow[1])*0.95 &&
                            food.proteins <= food.carbohydrates*(overflow[0]/overflow[1])*1.05
                    )
                }
                
                let extraFoodsFromDynamicPredicate = (array as NSArray).filtered(using: dynamicPredicate) as! [Food]
                
                if extraFoodsFromDynamicPredicate.count > 0{
                    #if debug
                    print("DYNAMIC PREDICATE FOUND SOMETHING \n\n \(extraFoodsFromDynamicPredicate.count)")
                    for each in extraFoodsFromDynamicPredicate{
                        print("Food found: \(each.name)")
                    }
                    #endif
                    
                    let numberOfMealsInDayMinusBreakfast = Double(numberOfMealsRemaining - 1)
                    for foodFound in extraFoodsFromDynamicPredicate{
                        if foodFound.servingSize?.name == Constants.grams{
                            if overflow[0]/foodFound.proteins > 1 * numberOfMealsInDayMinusBreakfast || overflow[1]/foodFound.carbohydrates > 1 * numberOfMealsInDayMinusBreakfast || overflow[2]/foodFound.fats > 1 * numberOfMealsInDayMinusBreakfast{
                                continue thecomebackBreak
                            }
                            if let max = foodFound.max_number_of_servings.value {
                                if (overflow[0]/foodFound.proteins) > max * numberOfMealsInDayMinusBreakfast || (overflow[1]/foodFound.carbohydrates) > max * numberOfMealsInDayMinusBreakfast || (overflow[2]/foodFound.fats) > max * numberOfMealsInDayMinusBreakfast{
                                    continue thecomebackBreak
                                }
                            }
                            
                        }
                    }
                    
                    var fi : [FoodItem] = []
                    for each in extraFoodsFromDynamicPredicate{
                        let foodItemo = FoodItem()
                        foodItemo.food = each
                        foodItemo.numberServing = overflow[0]/each.proteins
                        fi.append(foodItemo)
                    }
                    
                    
                    //let fi = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(extraFoodsFromDynamicPredicate, attribute: macro, desiredQuantity: deficient, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday, lastMealFlag: true, beforeComeBackFlag: false, dietaryRequirements: dietRequirements)
                    
                    
                    guard fi.count > 0  else {
                        #if debug
                        print("The food couldnn't be scaled so exiting the loop.")
                        #endif
                        break
                        
                    }
                    
                    for foodItemFound in fi{
                        dailyMealPlan = assignMealTo(Constants.PROTEINS, foodItem: foodItemFound, plan: dailyMealPlan)
                        let ka = ((foodItemFound.food!.calories) * foodItemFound.numberServing)
                        let ca = ((foodItemFound.food!.carbohydrates) * foodItemFound.numberServing)
                        let pr = ((foodItemFound.food!.proteins) * foodItemFound.numberServing)
                        let fa = ((foodItemFound.food!.fats) * foodItemFound.numberServing)
                        
                        macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                        macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                        macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                        macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                        //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    }
                    #if debug
                    print("leaving dynamic predicate section")
                    #endif
                    break thecomebackBreak
                    
                }
                
                
                
                //TO-DO: Need to sort foods using a custom sort function
                
                breakLabel: switch macro {
                case Constants.PROTEINS:
                    
                    
                    //break breakLabel
                    
                    deficient = macrosDesiredToday[Constants.PROTEINS]! - macrosAllocatedToday[Constants.PROTEINS]!
                    
                    let food :Food = Food()
                    var foodOptions : [Food] = [Food]()
                    
                    guard deficient > 0  else {
                        break breakLabel
                    }
                    
                    if deficient < Constants.maximumNumberOfGramsToIgnore {
                        break breakLabel
                    }
                    else if deficient >= 20{
                        proBreakLabel: for fo in highProteins{
                            if /*foodsAlreadySelected.contains(fo.name) == false && */fo.alwaysEatenWithOneOf.count == 0 && [Constants.ml, Constants.grams].contains((fo.servingSize?.name)!){
                                foodOptions.append(fo)
                                //food = fo
                            }
                        }
                        
                    } else {
                        proBreakLabel2: for fo in highProteins.reversed(){
                            if /*foodsAlreadySelected.contains(fo.name) == false &&*/ fo.alwaysEatenWithOneOf.count == 0 && [Constants.ml, Constants.grams].contains((fo.servingSize?.name)!){
                                foodOptions.append(fo)
                                //food = fo
                            }
                        }
                    }

                    foodOptions.sort(by: { x, y in
                        return x.proteins < x.proteins
                    })
                    
                    let overflow = [macrosDesiredToday[Constants.PROTEINS]! - dailyMealPlan.totalProteins(),
                                    macrosDesiredToday[Constants.CARBOHYDRATES]! - dailyMealPlan.totalCarbohydrates(),
                                    macrosDesiredToday[Constants.FATS]! - dailyMealPlan.totalFats()]
                    //let overflow = createOverFlowStructure(numberOfMealsRemaining, macrosAllocatedToday: macrosAllocatedToday, macrosDesiredToday: macrosDesiredToday)
                    
                    

                    //  && (food.carbohydrates*(overflow[2]/overflow[1]) || food.fats <= food.carbohydrates*(overflow[2]/overflow[1])*0.7)
                    // Terminating app due to uncaught exception 'Invalid predicate', reason: 'Only support compound, comparison, and constant predicates'
                    
                    
                    /*
                     if foodOptions contain foods that we already have in our meal plan then let's use those instead of making more food.
                     If not, ensure no more than two foods are used in the foodOptions and if the deficit < 20 then use just one item
                    */
                    let sameFoodsFound = foodOptions.filter{ foodsAlreadySelected.contains($0.name)}
                    
                    if sameFoodsFound.count > 0{
                        foodOptions = sameFoodsFound
                    }
                    
                    if foodOptions.count > 2{
                        //MARK - Preference for foods that already in the foodbasket
                        foodOptions = [foodOptions.first!, foodOptions[1]] // if 0, 1, or 2
                    }
                    if deficient < 20 {
                        foodOptions = [foodOptions.first!] //if we need less than 20g, then only select one food to be the hero.
                    }
                    
                    
                    #if debug
                    for each in foodOptions{
                        print("each protein: \(each.name) with \(each.proteins)per 100g")
                    }
                    #endif
                    
                    
                    let fi = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foodOptions, attribute: macro, desiredQuantity: deficient, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday, lastMealFlag: true, beforeComeBackFlag: false, dietaryRequirements: dietRequirements)
                    
                    
                    guard fi.count > 0  else {
                        #if debug
                        print("The food couldnn't be scaled so exiting the loop.")
                            #endif
                        break
                    }
                
                    //comeBackProteinFoodItem = fi.first!
                    
                    for foodItemFound in fi{
                        dailyMealPlan = assignMealTo(Constants.PROTEINS, foodItem: foodItemFound, plan: dailyMealPlan)
                        let ka = ((foodItemFound.food!.calories) * foodItemFound.numberServing)
                        let ca = ((foodItemFound.food!.carbohydrates) * foodItemFound.numberServing)
                        let pr = ((foodItemFound.food!.proteins) * foodItemFound.numberServing)
                        let fa = ((foodItemFound.food!.fats) * foodItemFound.numberServing)
                        
                        macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                        macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                        macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                        macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                        //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    }
                    //dailyMealPlan = assignMealTo(Constants.PROTEINS, foodItem: comeBackProteinFoodItem, plan: dailyMealPlan)

                    


                   
                    
                    
                case Constants.CARBOHYDRATES:
                    deficient = macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!

                    
                    //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    
                    var food :Food = Food()
                    var foodOptions : [Food] = [Food]()
                    
                    if deficient < Constants.maximumNumberOfGramsToIgnore {
                        break breakLabel
                    }
                    else if deficient < 20{
                        carbBreakLabel: for fo in extraCarbTreats{
                            if /*foodsAlreadySelected.contains(fo.name) == false &&*/ fo.alwaysEatenWithOneOf.count == 0 && [Constants.ml, Constants.grams].contains((fo.servingSize?.name)!){
                                foodOptions.append(fo)
                                //food = fo
                                //break carbBreakLabel
                            }
                        }
                    } else {
                        carbBreakLabel2: for fo in extraCarbTreats.reversed(){
                            if /*foodsAlreadySelected.contains(fo.name) == false &&*/ fo.alwaysEatenWithOneOf.count == 0 && [Constants.ml, Constants.grams].contains((fo.servingSize?.name)!){
                                foodOptions.append(fo)
                                //food = fo
                                //break carbBreakLabel2
                            }
                        }
                    
                    }
                    if food.name == ""{
                        let randomInt = Int(arc4random_uniform(UInt32(extraCarbTreats.count)))
                        //food = extraCarbTreats[randomInt]
                        foodOptions.append(extraCarbTreats[randomInt])
                    }
                    
                    let overflow = [macrosDesiredToday[Constants.PROTEINS]! - dailyMealPlan.totalProteins(),
                                    macrosDesiredToday[Constants.CARBOHYDRATES]! - dailyMealPlan.totalCarbohydrates(),
                                    macrosDesiredToday[Constants.FATS]! - dailyMealPlan.totalFats()]
                    //let overflow = createOverFlowStructure(numberOfMealsRemaining, macrosAllocatedToday: macrosAllocatedToday, macrosDesiredToday: macrosDesiredToday)

                    
                    let possibleOptions = foodsThatCanMeetMacroNeeds(foods: foodOptions, macro: macro, amountNeeded: overflow)
                    if possibleOptions.count > 0{
                        foodOptions = possibleOptions
                    }

                    
                    if foodOptions.count > 1{
                        let randomInt = Int(arc4random_uniform(UInt32(foodOptions.count)))
                        foodOptions = [foodOptions[randomInt]] // we only want a maximum of one comeback foods
                    }
                    //Sort by which will yield the most macronutrient, in desc order, else, sort by carbs (because this is the problem child), asc order
                    foodOptions.sort(by: { x, y in
                        if x.max_number_of_servings.value != nil && y.max_number_of_servings.value != nil{
                            return (x.max_number_of_servings.value! * x.carbohydrates) > (y.max_number_of_servings.value! * x.carbohydrates)
                        } else {
                            return x.carbohydrates < x.carbohydrates
                        }
                    })
                    
                    let fi = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foodOptions, attribute: macro, desiredQuantity: deficient, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday, lastMealFlag: true, beforeComeBackFlag: false, dietaryRequirements: dietRequirements)
                    
                    
                    if fi.count == 0 {
                        break
                    }
                    
                    for foodItemFound in fi{
                        dailyMealPlan = assignMealTo(macro, foodItem: foodItemFound, plan: dailyMealPlan)
                        let ka = ((foodItemFound.food!.calories) * foodItemFound.numberServing)
                        let ca = ((foodItemFound.food!.carbohydrates) * foodItemFound.numberServing)
                        let pr = ((foodItemFound.food!.proteins) * foodItemFound.numberServing)
                        let fa = ((foodItemFound.food!.fats) * foodItemFound.numberServing)
                        
                        macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                        macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                        macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                        macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                        //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    }
                    
                    
                    
                    
                case Constants.FATS:
                    deficient = macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!
                    
                    //let highFatOilPredicate = NSPredicate(format: "fats > 80 AND ANY SELF.oftenEatenWith IN %@", dailyMealPlan.foods())
                    
                    // Find any foods that have a fat content above 80, any of its oew foods are in the list of todays meal plan
                    let highFatOilPredicate = NSPredicate(format: "fats > 80 AND ANY SELF.oftenEatenWith IN %@", dailyMealPlan.foods())
                    
                    
                    let fPredicate : NSCompoundPredicate = NSCompoundPredicate(type: .or, subpredicates:[ highFatOilPredicate, superHighFatPredicate /*notCondiment dietaryRequirementPredicate,*/])
                    
                    let extraFatFoods = realm.objects(Food.self).filter(fPredicate).sorted(byProperty: Constants.FATS.lowercased(), ascending: true)
                    
                    //TODO: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    
                    
                    
                    var food :Food = Food()
                    var foodOptions : [Food] = [Food]()
                    
                    guard deficient > 0  else {
                        break breakLabel
                    }
                    if deficient < Constants.maximumNumberOfGramsToIgnore {
                        break breakLabel
                    }
                    else if deficient < 20{
                        for fo in extraFatFoods{
                            if fo.alwaysEatenWithOneOf.count == 0 && [Constants.ml, Constants.grams].contains((fo.servingSize?.name)!){
                                //food = fo //TODO - THIS IS NOT A RANDOM SELECTION
                                //print("LESS than 20g of FAT. \n")
                                //break
                                foodOptions.append(fo)
                            }
                        }
                    } else {
                        for fo in extraFatFoods.reversed(){
                            if fo.alwaysEatenWithOneOf.count == 0 && [Constants.ml, Constants.grams].contains((fo.servingSize?.name)!){
                                //food = fo //TO - THIS IS NOT A RANDOM SELECTION
                                //break
                                foodOptions.append(fo)
                            }
                        }
                    }
                    
                    /*
                    if food.name == ""{
                        let randomInt = Int(arc4random_uniform(UInt32(extraFatFoods.count)))
                        //food = extraFatFoods[randomInt]
                        foodOptions.append(extraFatFoods[randomInt])
                    }
                    */
                    
                    let overflow = [macrosDesiredToday[Constants.PROTEINS]! - dailyMealPlan.totalProteins(),
                                    macrosDesiredToday[Constants.CARBOHYDRATES]! - dailyMealPlan.totalCarbohydrates(),
                                    macrosDesiredToday[Constants.FATS]! - dailyMealPlan.totalFats()]
                    //let overflow = createOverFlowStructure(numberOfMealsRemaining, macrosAllocatedToday: macrosAllocatedToday, macrosDesiredToday: macrosDesiredToday)
                    
                    foodOptions.sort(by: { x, y in
                        return x.fats < x.fats
                    })
                    
                    if foodOptions.count > 2{
                        let randomInt = Int(arc4random_uniform(UInt32(extraFatFoods.count)))
                        foodOptions = [foodOptions[randomInt], foodOptions.last!] // we only want a maximum of 2 foods for the comeback
                        if foodOptions[0] == foodOptions[1]{
                            foodOptions = [foodOptions[0]]
                        }
                    }
                    
                    
                    for foo in foodOptions{
                    }
                    
                    if deficient < 20 {
                        let randomInt = Int(arc4random_uniform(UInt32(foodOptions.count)))
                        if foodOptions.count > 0{
                            foodOptions = [foodOptions[randomInt]]
                        }
                        //if we need less than 20g, then only select one food to be the hero.
                    }
                    
                    #if debug
                    for foo in foodOptions{
                        print("Chosen fats: \(foo.name)")
                    }
                    #endif
                    
                    let fi = apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(foodOptions, attribute: macro, desiredQuantity: deficient, overflowAmounts: overflow, macrosAllocatedToday: macrosAllocatedToday, lastMealFlag: true, beforeComeBackFlag: false, dietaryRequirements: dietRequirements)
                    
                    if fi.count == 0 {
                        break
                    }
                    
                    for foodItemFound in fi{
                        dailyMealPlan = assignMealTo(macro, foodItem: foodItemFound, plan: dailyMealPlan)
                        let ka = ((foodItemFound.food!.calories) * foodItemFound.numberServing)
                        let ca = ((foodItemFound.food!.carbohydrates) * foodItemFound.numberServing)
                        let pr = ((foodItemFound.food!.proteins) * foodItemFound.numberServing)
                        let fa = ((foodItemFound.food!.fats) * foodItemFound.numberServing)
                        
                        macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + ka
                        macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + ca
                        macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + pr
                        macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + fa
                        //TOD0: Ensure the foods selected are related (OEWOO) to the foods already in the basket OR do not have AEWOF unless it's already in the basket
                    }
                    
                    
                    //comeBackFattyFoodItem = fi.first!
                    
                case Constants.vegetableFoodType:
                    break
                    
                default:
                    break
                }
            }
            
                
                
            //TODO: Ensure that proteins has -10 by the time I get to the first pass of proteing in meal 4
            #if debug
            print("\n\nDailyMeal Plan:\nCalories: \(dailyMealPlan.totalCalories())\nCarbs: \(dailyMealPlan.totalCarbohydrates()) \nProtein: \(dailyMealPlan.totalProteins()) \nFats: \(dailyMealPlan.totalFats()) \n\n")
            
            print("Protein finished with: \(macrosDesiredToday[Constants.PROTEINS]! - dailyMealPlan.totalProteins())\n")
            print("Carbs finished with: \(macrosDesiredToday[Constants.CARBOHYDRATES]! - dailyMealPlan.totalCarbohydrates())\n")
            print("Fats finished with: \(macrosDesiredToday[Constants.FATS]! - dailyMealPlan.totalFats())\n")
            #endif
            //dailyMealPlan = removeDuplicatesFromMeal(plan: dailyMealPlan)
            
            // - PackageFoodsNicely - at the end - ensure no duplicates in meal, and ensure the ordering is nice 👌

            

            
            plans.append(dailyMealPlan)
            
            #if debug
            for foodArray in dailyMealPlan.meals{
                for foodItem in foodArray.foodItems{
                    csv3 += (foodItem.food?.name)! + ","
                    foodItem.numberServing = Constants.roundToPlaces(foodItem.numberServing, decimalPlaces: 2) // rounding for customer use
                }
                
                }
            csv3 += "\n"
            #endif
        }
        #if debug
        let fileManager = FileManager()
        let urls = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask) as [URL]
        
        if urls.count > 0 {
            let documentsFolder = urls[0]
            print("\(documentsFolder)")
        } else {
        }
        
        
        
        for csv in [csv1]{
            let destinationPath = NSTemporaryDirectory() + "testfly \(Date().timeIntervalSince1970*1000).csv"
            try! csv.write(toFile: destinationPath, atomically: true, encoding: String.Encoding.utf8)
            print("\nThe destination path is: \(destinationPath)\n")
                /*
                file?.writeData(csv.dataUsingEncoding(NSUTF8StringEncoding)!) // Set the data we want to write, write it to the file
                file?.closeFile() // Close the file
 */
        }
        #endif
        
        
        
        
        return plans
        }
    
    
    
    static func foodSortByServingType(_ f1: Food, _ f2: Food) -> Bool {
        let order = Constants.SERVING_SIZE_ORDER
        return order.index(of: (f1.servingSize?.name)!)! < order.index(of: (f2.servingSize?.name)!)!
    }
    
    
    static func mealSortByProteins(_ m1: Meal, _ m2: Meal) -> Bool {
        return m1.totalProteins() < m2.totalProteins()
    }
    
    static func mealSortByCarbs(_ m1: Meal, _ m2: Meal) -> Bool {
        return m1.totalCarbohydrates() < m2.totalCarbohydrates()
    }
    
    static func mealSortByFats(_ m1: Meal, _ m2: Meal) -> Bool {
        return m1.totalFats() < m2.totalFats()
    }
    
    
    static func foodsThatCanMeetMacroNeeds(foods: [Food], macro:String, amountNeeded:[Double]) ->[Food]{
        var canMeet : [Food] = []
        for food in foods{
            switch macro {
            case Constants.CARBOHYDRATES:
                let carbsNeeded = amountNeeded[1]
                if carbsNeeded/food.carbohydrates < 3.25 { // An extra .25 because the proteins and fats can help out.
                    if let max = food.max_number_of_servings.value{
                        if max <= carbsNeeded/food.carbohydrates{
                            canMeet.append(food)
                            continue
                        }
                    }
                    canMeet.append(food)
                    continue
                }
            default:
                break
            }
        }
        return canMeet
    }
    
    /**
     This sorting function finds out how many portions are needed to match the fat overflow requirement.
     It then assesses the proximity between the overflow and the remaining macros.
     The food with the closest nutritional profile is returned.
     
     - parameter food1: The first food to compare, food2: The second food to compare; overflow: The overflow as an array
     
     
     */
    static func foodSortedByApproximityToOverflow(_ food1: Food, _ food2: Food, overflow: [Double]) -> Bool {
        let factor = overflow[2]/food1.fats
        let proteinOutBy = (factor * food1.proteins) - overflow[0]
        let carbsOutBy = (factor * food1.carbohydrates) - overflow[1]
        let totalOutBy = (proteinOutBy + carbsOutBy)
        
        let factor2 = overflow[2]/food2.fats
        let proteinOutBy2 = (factor * food2.proteins) - overflow[0]
        let carbsOutBy2 = (factor * food2.carbohydrates) - overflow[1]
        let totalOutBy2 = (proteinOutBy + carbsOutBy)
        
        return totalOutBy < totalOutBy2
    }
    
    static func mealsSortedByProtein(_ meal1: Meal, _ meal2: Meal) -> Bool {
        return meal1.totalProteins() > meal2.totalProteins()
    }
    
    static func mealsSortedByCarbohydrates(_ meal1: Meal, _ meal2: Meal) -> Bool {
        return meal1.totalCarbohydrates() > meal2.totalCarbohydrates()
    }
    
    static func mealsSortedByFat(_ meal1: Meal, _ meal2: Meal) -> Bool {
        return meal1.totalFats() > meal2.totalFats()
    }

    
    

    /**
     This function checks the given meal plan for any duplicates within a meal. If duplicates are found the numberofServings are combined, the other item reduced to -1 and then removed via a filter.
     
     - parameter plan: The meal plan that we want to update.
     
     
     */
    static func removeDuplicatesFromMeal(plan:DailyMealPlan) ->DailyMealPlan{
        print("started with \(plan.meals.count) meals.")
        for meal in plan.meals{
            for fi in meal.foodItems{
                for (index, innerFi) in meal.foodItems.enumerated(){
                    if fi != innerFi && fi.food == innerFi.food {
                        meal.foodItems[index].numberServing += fi.numberServing
                        fi.numberServing = -1
                        print("CHECK: Just deleted a duplicate")
                    }
                }
            }
            
        }
        let lowCarbPredicate2 = NSPredicate(format: "numberServing != -1")
        let filter = plan.meals.filter(lowCarbPredicate2)
        plan.meals.removeAll()
        plan.meals.append(objectsIn: filter)
        
        return plan
    }
    
    
    
    
    /**
     This function attempts to assign the given food to the meal with the least amount of the stated macronutrient (e.g. it will attempt to allocate a fat food to the meal with the least amount of fat.
     
     
     - parameter macro: The macro that we trying to allocate.
     - parameter foodItem: The foodItem we are trying to place.
     - parameter plan: The meal plan that we want to update.
     
     
     */
    
    /*
    static func assignMealTo(_ macro:String, foodItem:FoodItem, plan:DailyMealPlan) ->DailyMealPlan{
    
        assert([Constants.PROTEINS, Constants.CARBOHYDRATES, Constants.FATS].contains(macro), "INVALID MACRO USED")
       
        let eatenAtBreakfast = DataHandler.getFoodType(Constants.eatenAtBreakfastFoodType)
        let eatenAtBreakfastFlag = (foodItem.food?.foodType.contains(eatenAtBreakfast))! ? true : false
        let breakFastOnly = DataHandler.getFoodType(Constants.onlyBreakfastFoodType)
        var lowestMeal = plan.meals[0]
        
        
        
        if (foodItem.food?.foodType.contains(breakFastOnly))!{
            lowestMeal.foodItems.append(foodItem)
            print("Assigning: \(foodItem.food?.name), for \(macro), to meal number \(lowestMeal.name)")
            return plan
        }
        
        var arrayOfMeals : [Meal] = [Meal]()
        for each in plan.meals{
            arrayOfMeals.append(each)
        }
        
        for meal in arrayOfMeals{
            if eatenAtBreakfastFlag == false && arrayOfMeals.index(of: meal) == 0{
                continue
            }
        }
        
        var assignedPlan : [Meal] = []
        switch macro {
        case Constants.PROTEINS:
            assignedPlan = arrayOfMeals.sorted(by: mealsSortedByProtein)
        case Constants.CARBOHYDRATES:
            assignedPlan = arrayOfMeals.sorted(by: mealsSortedByCarbohydrates)
        case Constants.FATS:
            assignedPlan = arrayOfMeals.sorted(by: mealsSortedByFat)
        default:
            assignedPlan = arrayOfMeals.sorted(by: mealsSortedByCarbohydrates)
        }
        
        print("PEEP: 1-\(assignedPlan)")
        for meal in assignedPlan{
            switch macro {
            case Constants.PROTEINS:
                print("meal has: \(meal.totalProteins())")
            case Constants.CARBOHYDRATES:
                print("meal has: \(meal.totalCarbohydrates())")
            case Constants.FATS:
                print("meal has: \(meal.totalFats())")
            default:
                breakFastOnly
            }
            
        }
        
        
        
        if assignedPlan.count > 1 && macro == Constants.PROTEINS && (foodItem.numberServing * (foodItem.food?.proteins)!) > 100{
            // Split protein amongst two meals if result is >50g each
            var halvedFoodItem = foodItem
            halvedFoodItem.numberServing = foodItem.numberServing/2
            
            let mealZeroIsBreakfast = assignedPlan[0] == plan.meals[0] ? true : false
            let mealOneIsBreakfast = assignedPlan[1] == plan.meals[1] ? true : false
            
            if mealZeroIsBreakfast == true && eatenAtBreakfastFlag == false {
                assignedPlan[1].foodItems.append(foodItem)
            } else if mealOneIsBreakfast == true && eatenAtBreakfastFlag == false{
                assignedPlan[0].foodItems.append(foodItem)
            } else {
                // neither of the two I want to send food to are breakfast and this not being a breakfast food, so apportion equally between the two meals
                assignedPlan[0].foodItems.append(halvedFoodItem)
                assignedPlan[1].foodItems.append(halvedFoodItem)
            }
            let newDailyMealPlan = plan
            newDailyMealPlan.meals.removeAll()
            newDailyMealPlan.meals.append(objectsIn: assignedPlan)
            print("PEEP: 2-\(assignedPlan)")
            return newDailyMealPlan
        }
        
        
        // If we have an amount smaller than the min required and can find the same food already in the meal plan then try and combine, else leave
        if let min = foodItem.food?.min_number_of_servings.value{
            if foodItem.numberServing < min {
                for meal in plan.meals{
                    if let matchedFoodItem = meal.getFoodItem(food: foodItem.food!){
                        if matchedFoodItem.numberServing == foodItem.numberServing{
                            //same fooditem so ignore
                            continue
                        } else {
                            matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                            print("adding servings for \(matchedFoodItem.food?.name) to make a combined: \(matchedFoodItem.numberServing)")
                            return plan
                        }
                        
                    }
                }
            }
            
        }
        
        return plan

        
        
       
        
        
        
        
                
       /*
        for (index,meal) in plan.meals.enumerated(){
            if eatenAtBreakfastFlag == false && index == 0{
                lowestMeal = plan.meals[1] // the lowest meal is meal number 2, as we can't use breakfast for this food which is not eaten at breakfast.
                continue
            }
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
                if let matchedFoodItem = meal.getFoodItem(food: foodItem.food!){
                    print("Found the same food in the same meal, will add to this food.")
                    matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                    return plan
                } else {
                    meal.foodItems.append(foodItem)
                }
                print("Assigning: \(foodItem.food?.name), for \(macro), to meal number \(meal.name)")
            }
        }
        return plan
      */
    }
   */
    
    static func assignMealTo(_ macro:String, foodItem:FoodItem, plan:DailyMealPlan) ->DailyMealPlan{
        var mealsContainingFood = plan.mealsThatContainFood(foodItem.food!)
        
        let eatenAtBreakfast = DataHandler.getFoodType(Constants.eatenAtBreakfastFoodType)
        let eatenAtBreakfastFlag = (foodItem.food?.foodType.contains(eatenAtBreakfast))! ? true : false
        let breakFastOnly = DataHandler.getFoodType(Constants.onlyBreakfastFoodType)
        var lowestMeal = plan.meals[0]
        if (foodItem.food?.foodType.contains(breakFastOnly))!{
            if let matchedFoodItem = lowestMeal.getFoodItem(food: foodItem.food!) {
                matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
            } else {
                lowestMeal.foodItems.append(foodItem)
            }
            return plan
        }
        
        var arrayOfMeals : [Meal] = [Meal]()
        for meal in plan.meals{
            arrayOfMeals.append(meal)
        }
        var newPlan : [Meal] = []
        var macroAmount = 0.0
        switch macro {
        case Constants.PROTEINS:
            mealsContainingFood = mealsContainingFood.sorted(by: mealsSortedByProtein)
            newPlan = arrayOfMeals.sorted(by: mealsSortedByProtein) // descending
            macroAmount = (foodItem.food?.proteins)! * foodItem.numberServing
        case Constants.CARBOHYDRATES:
            mealsContainingFood = mealsContainingFood.sorted(by: mealsSortedByCarbohydrates)
            newPlan = arrayOfMeals.sorted(by: mealsSortedByCarbohydrates)
            macroAmount = (foodItem.food?.carbohydrates)! * foodItem.numberServing
        case Constants.FATS:
            mealsContainingFood = mealsContainingFood.sorted(by: mealsSortedByFat)
            newPlan = arrayOfMeals.sorted(by: mealsSortedByFat)
            macroAmount = (foodItem.food?.fats)! * foodItem.numberServing
        default:
            mealsContainingFood = mealsContainingFood.sorted(by: mealsSortedByCarbohydrates)
            newPlan = arrayOfMeals.sorted(by: mealsSortedByCarbohydrates)
            macroAmount = (foodItem.food?.carbohydrates)! * foodItem.numberServing
        }
        
        let secondFromLastIndex = newPlan.count - 1
        let secondLowestMeal = plan.getMeal(mealToFind: newPlan[secondFromLastIndex-1])
        lowestMeal = plan.getMeal(mealToFind: newPlan.last!)!

        
        if eatenAtBreakfastFlag == true {
            if macroAmount < 50 && mealsContainingFood.count > 0{
                //plan.getMeal(mealToFind: mealsContainingFood.last!)?.foodItems.append(foodItem)
                let mealo = plan.getMeal(mealToFind: mealsContainingFood.last!)
                if let matchedFoodItem = mealo?.getFoodItem(food: foodItem.food!) {
                    matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                } else {
                    mealo?.foodItems.append(foodItem)
                }
            } else {
                if let matchedFoodItem = lowestMeal.getFoodItem(food: foodItem.food!) {
                    matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                } else {
                    lowestMeal.foodItems.append(foodItem)
                }
            }
        }
        else if eatenAtBreakfastFlag == false && plan.meals[0].isEqual(lowestMeal){
            // if it's not a breakfast food but breakfast is the lowest
            
            if macroAmount < 50 && mealsContainingFood.count > 0{
                let mealo = plan.getMeal(mealToFind: mealsContainingFood.last!)
                if let matchedFoodItem = mealo?.getFoodItem(food: foodItem.food!) {
                    matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                } else {
                    mealo?.foodItems.append(foodItem)
                }
                //plan.getMeal(mealToFind: mealsContainingFood.last!)?.foodItems.append(foodItem)
            } else {
                if let matchedFoodItem = secondLowestMeal?.getFoodItem(food: foodItem.food!) {
                    matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                } else {
                    secondLowestMeal?.foodItems.append(foodItem)
                }
            }
        }
        else if eatenAtBreakfastFlag == false && plan.meals[1].isEqual(lowestMeal){
            // if it's not a breakfast food but breakfast is the lowest
            if macroAmount < 50 && mealsContainingFood.count > 0{
                let mealo = plan.getMeal(mealToFind: mealsContainingFood.last!)
                if let matchedFoodItem = mealo?.getFoodItem(food: foodItem.food!) {
                    matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                } else {
                    mealo?.foodItems.append(foodItem)
                }
                //plan.getMeal(mealToFind: mealsContainingFood.last!)?.foodItems.append(foodItem)
            } else {
                if let matchedFoodItem = lowestMeal.getFoodItem(food: foodItem.food!) {
                    matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
                } else {
                    lowestMeal.foodItems.append(foodItem)
                }
            }
        } else {
            if let matchedFoodItem = lowestMeal.getFoodItem(food: foodItem.food!) {
                matchedFoodItem.numberServing = matchedFoodItem.numberServing + foodItem.numberServing
            } else {
                lowestMeal.foodItems.append(foodItem)
            }
        }
        #if debug
         print("\nPlan @ end:\nCalories: \(plan.totalCalories())\nCarbs: \(plan.totalCarbohydrates()) \nProtein: \(plan.totalProteins()) \nFats: \(plan.totalFats()) \n\n")
        #endif
        return plan
    }
    
    

                        
    func addNewPredicateToCompound(_ predicate:NSPredicate, compoundPredicate:NSCompoundPredicate) -> NSCompoundPredicate{
        
        var subPredicates : [NSPredicate] = []
        subPredicates.append(contentsOf: compoundPredicate.subpredicates as! [NSPredicate])
        let cPredicate : NSCompoundPredicate = NSCompoundPredicate(type: .and, subpredicates:subPredicates)
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
    func shouldAllowAdditionToMeal(_ dailymeal:DailyMealPlan, food:Food, basket:[Food], macrosDict:[String:Double], week:Week) ->Bool{
        
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
            let dateOfMealPlan = NSCalendar.current.date(byAdding: .day, value: dailyMeal.dayId, to: week.start_date)
            foodIsFromToday = NSCalendar.current.isDateInToday(dateOfMealPlan!)
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
        let predicate = NSPredicate(format: "self == %@", food as! CVarArg)
        let foodCountToday = (listOfFoodsFromToday as NSArray).filtered(using: predicate).count
        let foodCountThisWeek = (listOfFoodsFromThisWeek as NSArray).filtered(using: predicate).count
        if (foodCountToday > 2) || (foodCountThisWeek > 4)  {
            return false
        }
        else {
            return true
        }
        
    }
    
    
    
    
    static func constrainPortionSizeBasedOnFood(_ fi:FoodItem, highFatAllowedFlag:Bool, dietaryRequirements: List<DietSuitability>) ->(FoodItem){
        // ensure that the fooditem returned contains a sensible serving size.
        
        var fooditem : FoodItem = fi
        let condiment = DataHandler.getCondimentFoodType()
        
        if Constants.isFat.evaluate(with: fooditem.food) && highFatAllowedFlag == false {
            fooditem.numberServing = 0.1 //10g or 10ml of fat
            return fooditem
        }
        
        if let max = fooditem.food?.max_number_of_servings.value {
            if fooditem.numberServing > max {
                fooditem.numberServing = max
                return fooditem
            }
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
                if fooditem.numberServing < 0.05{
                    fooditem.numberServing = 0
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
                print("ERROR: This serving size has not been recognised.")
                break
            }
            
            if condiment.name != "" {
                if ((fooditem.food?.foodType.contains(condiment)) == true){
                    if fooditem.numberServing > 0.25{
                        fooditem.numberServing = 0.25
                        // if it's greater than 25g or 25ml then turn it down and make it 25.
                    }
                }
            }
        
        //Constrain vegetable amounts
        
        
        let vegFoodType = DataHandler.getFoodType(Constants.vegetableFoodType)
        let vegetarianVeganUser = (dietaryRequirements.first?.name == Constants.vegetarian || dietaryRequirements.first?.name == Constants.Vegan ) ? true : false
        
        //if vegetarian then do not restrict the amount of vegetables he or she can eat
        if (fooditem.food?.foodType.contains(vegFoodType))! && (Double((fooditem.food?.carbohydrates)!) < 10.00) && vegetarianVeganUser == false {
            if fooditem.numberServing > 1{
                fooditem.numberServing = 1
            }
            if fooditem.numberServing < 0.2{
                fooditem.numberServing = 0
            }
        }
        
        #if debug
        print("Exiting constrains with: \(fooditem.numberServing)")
        #endif
        return fooditem
        
    }
    
        /*

     if a condiment then no more than 25g,
     if slices then no more than 4,
     if it's ml then no more than 500ml unless it's water,
     if it's a heaped teaspoon no more than 4
     
 
    */
    
    
    // MARK: TO-DO: REMOVE 'desiredQuantity' from  the function signature below
    
    /**
    This function takes a given food and returns a fooditem with the given amount of a macro. For example Bread, fat:20g will return a fooditem that contains enough bread to give 20g of fat.
    
    
    - parameter food: A food object.
    - parameter attribute: 'carbs', 'proteins', or 'fats'.
    - parameter desiredQuantity: ...
     
    
    
    */
    static func apportionFoodToGetGivenAmountOfMacroWithoutOverFlow(_ foods:[Food], attribute:String, desiredQuantity:Double, overflowAmounts:[Double], macrosAllocatedToday:[String:Double], lastMealFlag:Bool, beforeComeBackFlag:Bool, dietaryRequirements: List<DietSuitability>)->[FoodItem]
    {
        var leftOverForThisMeal = overflowAmounts
        if beforeComeBackFlag == true{
            leftOverForThisMeal[0] = leftOverForThisMeal[0] - 12
            leftOverForThisMeal[1] = leftOverForThisMeal[1] - 7
            leftOverForThisMeal[2] = leftOverForThisMeal[2] - 7
        } else {
            if attribute == Constants.CARBOHYDRATES{
                leftOverForThisMeal[1] = leftOverForThisMeal[1] - 7
            }
        }
        
        var foodItems : [FoodItem] = []
        var indices : [Int] = []
        var requiredAmount = 0.0
        
        
        // Need to update the overflowAmounts variable if there are more than one foods
        
        foodloop: for (loopCount,food) in foods.enumerated() {
            var foodAttributeAmount = Double()
            switch attribute {
            case Constants.PROTEINS:
                foodAttributeAmount = food.proteins
                indices = [1,2]
                requiredAmount = leftOverForThisMeal[0]
                
            case Constants.CARBOHYDRATES:
                foodAttributeAmount = food.carbohydrates
                indices = [0,2]
                requiredAmount = leftOverForThisMeal[1]
            
            case Constants.vegetableFoodType:
                foodAttributeAmount = food.carbohydrates
                indices = [0,2]
                requiredAmount = leftOverForThisMeal[1]
                
            case Constants.FATS:
                foodAttributeAmount = food.fats
                indices = [0,1]
                requiredAmount = leftOverForThisMeal[2]

            default:
                foodAttributeAmount = food.carbohydrates
            }
            
            // TODO - if attribute is 0.0 then exit
            
            var cushionForFats = 0.0
            let loopsRemaining = Double(foods.count) - Double(loopCount)
            var index = [food.proteins, food.carbohydrates, food.fats]
            var fooditem = FoodItem()
            fooditem.food = food
            
            let macro1ForFoodItem = (fooditem.numberServing * index[indices[0]])
            let macro2ForFoodItem = (fooditem.numberServing * index[indices[1]])
            
            /*
             Whilst the protein or carb from this food is above the limit, reduce the item size a tiny amount and test again.
             */
            if loopCount+1 == foods.count && beforeComeBackFlag == true {
                // this is the last of the foods in the array and its 'before the comeback', ensure it doesn't leave with less than 5g of any macro
                requiredAmount = requiredAmount - Double(foods.count * 7)
            }
            
            
            guard foodAttributeAmount != 0.0 else {
                print("Big error.")//MARK: TODO - BETTER ERROR HANDLING HERE
                return [FoodItem()]
            }
            let foodCountMinusLoop = Double(foods.count) - Double(loopCount)
            fooditem.numberServing = (requiredAmount/foodCountMinusLoop)/foodAttributeAmount // so its divided amongst the # of foods for this macro
            
            
            if attribute == Constants.PROTEINS {
                
                if leftOverForThisMeal[1] > Constants.maximumNumberOfGramsToIgnore && leftOverForThisMeal[2] > Constants.maximumNumberOfGramsToIgnore && lastMealFlag == false{
                    // because everything has a little bit of protein and by the time I get to carbs, fats, and veg, it will up to 100% or more
                    cushionForFats = 7.0
                }
            }
            
            if attribute == Constants.CARBOHYDRATES {
                if lastMealFlag == false || beforeComeBackFlag == true{
                    fooditem.numberServing = fooditem.numberServing * (1 - Constants.vegetablesAsPercentageOfCarbs) // 7% of carb allowance reserved for vegetables
                } // else we want the full whack.
                
                
                
                
            }
            #if debug
            print("Starting point is a serving size of : \(fooditem.numberServing)")
                #endif
            // But not allowed to overflow, so...
            
            //IMPROVEMENT: We may as well exit here if we have negative numbers.
            
            
            //if we have negative values, making it one means pure substances such as oil can still work.
            if index[indices[0]] < 0 {
                index[indices[0]] = 1
            }
            if index[indices[1]] < 0 {
                index[indices[1]] = 1
            }
            
            #if debug
            print("Last meal flag is : \(lastMealFlag.description)\n")
                #endif
            if lastMealFlag == true {
                leftOverForThisMeal[indices[0]] = leftOverForThisMeal[indices[0]] + 6.0  // give it some extra leeway of 5gs as it's not far off from giving back something (more than 0.15)
                leftOverForThisMeal[indices[1]] = leftOverForThisMeal[indices[1]] + 6.0
            }
            
            /*
             This checks that 15g of this product will not exceed the limits we have. If so, then don't waste time and let's move on.
             */
            if ((0.15 * index[indices[0]])  <= (leftOverForThisMeal[indices[0]]/Double(foods.count))) && ((0.15 * index[indices[1]])  <= leftOverForThisMeal[indices[1]]/Double(foods.count)) {
                
                
                
                
                while ((fooditem.numberServing * index[indices[0]]) /*+ cushionForFats*/  > (leftOverForThisMeal[indices[0]]/loopsRemaining)) || ((fooditem.numberServing * index[indices[1]]) /*+ cushionForFats*/  > (leftOverForThisMeal[indices[1]]/loopsRemaining)){
                    
                    fooditem.numberServing = (fooditem.numberServing - 0.01)
                    if fooditem.numberServing < 0 {
                        fooditem.numberServing = 0
                        #if debug
                        print("\(fooditem.food?.name) has a serving size below 0. The macro is: \(Constants.MACRONUTRIENTS[0]) of \(macro1ForFoodItem) and the leftOverForThisMeal is: \(leftOverForThisMeal[indices[0]]) \n")
                            #endif
                        break
                    }
                }
                if fooditem.numberServing == 0 && fooditem.food?.doNotReduceToZero == true {
                    if let min = fooditem.food?.min_number_of_servings.value{
                        fooditem.numberServing = min
                    }
                    
                }
            } else {
                fooditem.numberServing = 0
            }
            
            
            
           #if debug
            print("For \(food.name), ended up with serving size of \(fooditem.numberServing)\n\n")
            #endif
            //find out the macros that we need to deal with - macros minus me

            
            
            
            if (food.servingSize?.name != Constants.grams) && (food.servingSize?.name != Constants.ml) {
                //round up to the closet whole number as we can only have 1 egg, or 2 pots etc
                if fooditem.numberServing > 0 && fooditem.numberServing < 0.5  {
                    fooditem.numberServing = 0
                    if lastMealFlag && attribute != Constants.FATS{
                        fooditem.numberServing = 0.5
                    }
                } else if fooditem.numberServing > 0.5 && fooditem.numberServing < 1 {
                    fooditem.numberServing = 1
                }
                else {
                    switch attribute {
                    case Constants.PROTEINS:
                        // if this foods current numberServing will leave me with too small carbs to work with in future loops then give it some space and round down.
                        if (leftOverForThisMeal[1] - (fooditem.numberServing * (fooditem.food?.carbohydrates)!)) < 5 || (leftOverForThisMeal[2] - (fooditem.numberServing * (fooditem.food?.fats)!)) < 5{
                            //give it a little room to breathe for the other macros
                            fooditem.numberServing = floor(fooditem.numberServing)
                        }
                        fooditem.numberServing = ceil(fooditem.numberServing)
                        
                    case Constants.CARBOHYDRATES:
                        let roundedDown = floor(fooditem.numberServing) * (fooditem.food?.carbohydrates)!
                        let roundedUp = ceil(fooditem.numberServing) * (fooditem.food?.carbohydrates)!
                        let roundedMidway = (floor(fooditem.numberServing)+0.5) * (fooditem.food?.carbohydrates)!
                        let nums = [roundedDown, roundedUp, roundedMidway]
                        
                        var distances : [Double] = []
                        var positiveDistances : [Double] = []
                        for number in nums {
                            let distance = leftOverForThisMeal[1] - number
                            distances.append(distance)
                            if distance > 0{
                                positiveDistances.append(distance)
                            }
                        }
                        
                        
                        distances = distances.sorted()
                        positiveDistances = positiveDistances.sorted()
                        
                        let leastDistance = min(distances[0] * -1, positiveDistances[0])
                        
                        var least = 0.0
                        if leastDistance == positiveDistances[0]{
                            least = positiveDistances[0]
                        } else {
                            least = distances[0]
                        }
                        #if debug
                        print("distances array:\(distances)")
                            #endif
                        let indexOfClosestNumberToZero = distances.index(of: least)
                        
                        //let closestServingSize = min(distances[0], distances[1], distances[2])// shortest distance from leftOverForThisMeal[0]
                        let indexOfClosestSize = distances.index(of: distances[0])!
                        let indexOfClosestPositiveSize = distances.index(of: positiveDistances[0])!
                        
                        //var o = lastMealFlag ? nums[indexOfClosestNumberToZero!] : nums[indexOfClosestPositiveSize]
                        var o = 0.0
                        if lastMealFlag == true {
                            o = nums[indexOfClosestNumberToZero!]
                        } else {
                            o = (nums[indexOfClosestPositiveSize] - (fooditem.numberServing * (fooditem.food?.carbohydrates)!) > 10 ? nums[indexOfClosestPositiveSize] : nums[indexOfClosestNumberToZero!] )
                            
                        }
                        #if debug
                        print("Going to test for \(o)")
                            #endif
                        if let indexInNums = nums.index(of: o) {
                            /*
                             If this is the last meal then the return the closest serving size.
                             Otherwise, return the closest distance than is no greater than what is required.
                             */
                            
                            switch indexInNums {
                            case 0:
                                fooditem.numberServing = floor(fooditem.numberServing)
                                #if debug
                                print("rounded carb down\n")
                                #endif
                            case 1:
                                fooditem.numberServing = ceil(fooditem.numberServing)
                                #if debug
                                print("rounded carb up\n")
                                #endif
                            case 2:
                                fooditem.numberServing = floor(fooditem.numberServing)+0.5
                                #if debug
                                print("rounded carb middway\n")
                                #endif
                            default:
                                #if debug
                                print("Error in rounding found")
                                #endif
                            }
                            
                        }
                        
                    
                    case Constants.FATS:
                        fooditem.numberServing = ceil(fooditem.numberServing)
                        
                    default:
                        break
                    }
                }
            }
            
            
            //DataHandler.createFoodItem(fooditem)
            
            if fooditem.numberServing > 0{
                fooditem = constrainPortionSizeBasedOnFood(fooditem, highFatAllowedFlag: lastMealFlag, dietaryRequirements: dietaryRequirements)
                if fooditem.numberServing >= 0.05{ // as constrain may have made it 0.
                    foodItems.append(fooditem)
                    #if debug
                    print("Just added: \(fooditem.food?.name)\n")
                    #endif
                    leftOverForThisMeal[0] = leftOverForThisMeal[0] - (fooditem.numberServing * food.proteins)
                    leftOverForThisMeal[1] = leftOverForThisMeal[1] - (fooditem.numberServing * food.carbohydrates)
                    leftOverForThisMeal[2] = leftOverForThisMeal[2] - (fooditem.numberServing * food.fats)
                }
                
            }
            
            
        }
        return foodItems
    }
    
    
    

    


}







