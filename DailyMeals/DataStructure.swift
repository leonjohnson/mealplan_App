import UIKit
import RealmSwift

class DataStructure : NSObject{
    
    
    static func createFood(){
        
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
    static func createMealPlans(){
        
        DataHandler.updateServingSizes()
        
        let realm = try! Realm()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)

        
        // Get the data
        let likedFoods = DataHandler.getLikeFoods()
        let dislikedFoods = DataHandler.getDisLikedFoods().foods
        let macros = DataHandler.getThisWeek().macroAllocation
        let kcal = DataHandler.getThisWeek().calorieAllowance
        let bio = DataHandler.getActiveBiographical()
        let dietaryNeed = bio.dietaryMethod
        let desiredNumberOfDailyMeals = bio.numberOfDailyMeals
        
        //Predicates
        var listOfAndPredicates : [NSPredicate] = []
        var listOfORPredicates : [NSPredicate] = []
        let lowCarbPredicate = NSPredicate(format: "carbohydrates < 10")
        let highCarbPredicate = NSPredicate(format: "carbohydrates > 10")
        let vegetablePredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.vegetableFoodType)
        let lowFatPredicate = NSPredicate(format: "fats < 8")
        let highProteinPredicate = NSPredicate(format: "(proteins > 15) AND (fats < 10) AND (carbohydrates < 60)")
        let fatTreatPredicate = NSPredicate(format: "fats BETWEEN {15, 40} AND carbohydrates BETWEEN {4,10}")
        let carbTreatPredicate = NSPredicate(format: "carbohydrates BETWEEN {14, 80}")
        let likedFoodsPredicate = NSPredicate(format: "self.name in %@", likedFoods)
        let dislikedFoodsPredicate = NSPredicate(format: "NOT SELF.name IN %@", dislikedFoods)
        // let predicate = NSPredicate(format: "NOT name IN %@", namesStr)
        let dietaryNeedPredicate = NSPredicate(format: "self.dietSuitablity.name == %@", dietaryNeed!)
        let noPretFood = NSPredicate(format: "NOT name CONTAINS[c] 'PRET'")
        var compoundPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: listOfAndPredicates)
        let onlyBreakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.onlyBreakfastFoodType)
        let eatenAtBreakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.eatenAtBreakfastFoodType)
        
        //Bool
        let random_yay_nay = arc4random_uniform(2)
        
        //divide kcal required by number of meals, each one should not be +-20% of this
        var macrosDesiredToday : [String:Int] = [Constants.CALORIES:3200, Constants.CARBOHYDRATES:300, Constants.PROTEINS:300, Constants.FATS:105/*Int(macros[2].value)*/]
        var macrosAllocatedToday = [Constants.CALORIES:0, Constants.CARBOHYDRATES:0, Constants.PROTEINS:0, Constants.FATS:0]
        var carbsLeftForToday : Int
        var proteinsLeftForToday : Int
        var fatsLeftForToday : Int
        
        
        var week = Week()
        
        
        if desiredNumberOfDailyMeals > 5 {
            //return
        }
        
        // Create the desiredNumberOfDailyMeals for 7 days
        // Put this week into a Week object.
        // Do the same for next week.
        
        
            
        for dayIndex in 1...7 {
            var dailyMealPlan = DailyMealPlan()
            dailyMealPlan.dayId = dayIndex
            
            for mealIndex in 1...desiredNumberOfDailyMeals{
                
                print("Day \(dayIndex), meal \(mealIndex)")
                
                var foodBasket :[String :[Food]] = [Constants.PROTEINS:[], Constants.CARBOHYDRATES:[],Constants.FATS:[], Constants.vegetableFoodType:[]]
                var sortedFoodBasket :[String :[Food]] = [Constants.PROTEINS:[], Constants.CARBOHYDRATES:[],Constants.FATS:[], Constants.vegetableFoodType:[]]
                var sortedFoodItemBasket :[String :[FoodItem]] = [Constants.PROTEINS:[], Constants.CARBOHYDRATES:[],Constants.FATS:[], Constants.vegetableFoodType:[]]
                
                listOfORPredicates = []
                listOfAndPredicates = []
                listOfAndPredicates.appendContentsOf([dislikedFoodsPredicate, highProteinPredicate])
                
                if mealIndex == 1{
                    //listOfAndPredicates.append(eatenAtBreakfastPredicate)
                    //listOfORPredicates.append(onlyBreakfastPredicate)
                    //random_yay_nay == 0 ? listOfPredicates.append(lowFatPredicate) : listOfPredicates.append(lowCarbPredicate)
                    listOfAndPredicates.append(lowFatPredicate)
                }
                
                if mealIndex == desiredNumberOfDailyMeals{
                    listOfAndPredicates.append(lowFatPredicate)
                    listOfAndPredicates.append(noPretFood)
                }
                
                let newAndCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfAndPredicates)
                //let newOrCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: listOfORPredicates)
                let foodResults = realm.objects(Food).filter(newAndCompoundPredicate)//.filter(newOrCompoundPredicate)
                var randomNumber : UInt32 = arc4random_uniform(UInt32(foodResults.count))
                
                
                if foodResults.count > 0{
                    let p = foodResults[Int(randomNumber)]
                    var pro = foodBasket[Constants.PROTEINS]
                    pro?.append(p)
                    foodBasket[Constants.PROTEINS]?.append(p)
                    
                    if p.alwaysEatenWithOneOf.count > 0{
                        // one of these must be choosen. It will be a carb because only carbs will be paired with protein sources.
                        let options = p.alwaysEatenWithOneOf.filter(dislikedFoodsPredicate)
                        randomNumber = arc4random_uniform(UInt32(options.count))
                        foodBasket[Constants.CARBOHYDRATES]?.append(options[Int(randomNumber)])
                    }
                    
                    //Applies to all circumstances...if a high protein diet then get a second source of protein to mix it up
                    if macrosDesiredToday[Constants.PROTEINS] > 200 {
                        // ensure we don't select the same item
                        var newRandNum = arc4random_uniform(UInt32(foodResults.count))
                        while randomNumber == newRandNum {
                            newRandNum = arc4random_uniform(UInt32(foodResults.count))
                        }
                        // get a second one
                        foodBasket[Constants.PROTEINS]?.append(foodResults[Int(newRandNum)])
                    }
                    
                    
                    //Carbs if required FOR THIS MEAL!
                    let carbsNeededToday : Int = macrosDesiredToday[Constants.CARBOHYDRATES]! - macrosAllocatedToday[Constants.CARBOHYDRATES]!
                    
                    var carbOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, highCarbPredicate]))
                    let OEWcarbOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, highCarbPredicate]))
                    if carbsNeededToday > 0 && carbOptions.count > 0 {
                        if OEWcarbOptions.count > 0{
                            carbOptions = OEWcarbOptions
                        }
                        randomNumber = arc4random_uniform(UInt32(carbOptions.count))
                        foodBasket[Constants.CARBOHYDRATES]?.append(carbOptions[Int(randomNumber)])
                    }
                    

                    
                    //fats if required FOR THIS MEAL!
                    let fatsNeededToday : Int = macrosDesiredToday[Constants.FATS]! - macrosAllocatedToday[Constants.FATS]!
                    
                    var fatOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, fatTreatPredicate]))
                    let OEWfatOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, fatTreatPredicate]))
                    if fatsNeededToday > 0 && fatOptions.count > 0 {
                        if OEWfatOptions.count > 0{
                            fatOptions = OEWfatOptions
                        }
                        randomNumber = arc4random_uniform(UInt32(fatOptions.count))
                        foodBasket[Constants.FATS]?.append(fatOptions[Int(randomNumber)])
                    }
                    
                    
                    //vegetables or fruit
                    if mealIndex > 1{
                        var vegetableOptions = realm.objects(Food).filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, vegetablePredicate]))
                        let OEWvegetableOptions = p.oftenEatenWith.filter(NSCompoundPredicate(andPredicateWithSubpredicates: [dislikedFoodsPredicate, vegetablePredicate]))
                        if OEWvegetableOptions.count > 0{
                            vegetableOptions = OEWvegetableOptions
                        }
                        for vegIndex in 1...vegetableOptions.count{
                            if vegIndex > 4{
                                foodBasket[Constants.vegetableFoodType]?.append(vegetableOptions[vegIndex])
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
                    
                    
                    
                    
                    for (key,foodArray) in foodBasket{
                        print("\(key) == \(foodArray.count)")
                        foodArrayEmpty: if foodArray.isEmpty{
                            break foodArrayEmpty
                        } else {
                            print("trying to sort: \(key)")
                            for each in foodArray{
                                print("trying to sort: \(each.name)")
                            }
                            
                            sortedFoodBasket[key]?.appendContentsOf(foodArray.sort(foodSort))
                        }
                        
                    }
                    //divide kcal required by number of meals, each one should not be +-20% of this
                    let numberOfMealsRemaining = desiredNumberOfDailyMeals - mealIndex
                    for (key, foodArray) in sortedFoodBasket{
                        
                        var findMoreFoods = false
                        if foodArray.count > 0
                        {
                            //Get the remaining amount left for today, for this macronutrient, and divide it amongst the remaining number of meals for today
                            let desiredToday = Double((macrosDesiredToday[key]!))
                            let allocatedtoday = Double((macrosAllocatedToday[key]!))
                            let desiredAmount = (desiredToday - allocatedtoday) / Double(numberOfMealsRemaining)
                            //print("IMPORTANT \n desiredToday:\(desiredToday) \n allocatedtoday:\(allocatedtoday) \n desiredAmount:\(desiredAmount) \n")
                            
                            repeat {
                                let results = apportionFoodToGetGivenAmountOfMacro(foodArray, attribute: key, desiredQuantity: desiredAmount)
                                sortedFoodItemBasket[key]?.appendContentsOf(results.foodItems)
                                
                                for fi in results.foodItems{
                                    let ka = fi.food?.calories
                                    let ca = fi.food?.carbohydrates
                                    let pr = fi.food?.proteins
                                    let fa = fi.food?.fats
                                    macrosAllocatedToday[Constants.CALORIES] = macrosAllocatedToday[Constants.CALORIES]! + Int(ka!)
                                    macrosAllocatedToday[Constants.CARBOHYDRATES] = macrosAllocatedToday[Constants.CARBOHYDRATES]! + Int(ca!)
                                    macrosAllocatedToday[Constants.PROTEINS] = macrosAllocatedToday[Constants.PROTEINS]! + Int(pr!)
                                    macrosAllocatedToday[Constants.FATS] = macrosAllocatedToday[Constants.FATS]! + Int(fa!)
                                }
                                
                                findMoreFoods = results.isAddittionalFoodRequired
                            } while findMoreFoods
                            
                            
                            
                            
                            //CHECK with delegate method before selection.
                            
                            // NOW NEED TO UPDATE - macrosAllocatedToday WITH fItem
                            
                        }
                        
                    }
                    
                }
                else
                {
                    print("NO FOOD RESULTS FOUND")
                }
                
                
                
                var count = 0
                for (key, foodArray) in sortedFoodItemBasket{
                    count = count+1
                    print("\(key.capitalizedString) has \(foodArray.count) items:")
                    for foodItem in foodArray{
                        print("\(count):  \(foodItem.food!.name.capitalizedString), \n Serving size: \(foodItem.numberServing) \n Proteins: \(foodItem.food!.proteins*foodItem.numberServing), \n carbs: \(foodItem.food!.carbohydrates*foodItem.numberServing), \n fats: \(foodItem.food!.fats*foodItem.numberServing) \n kcal : \(foodItem.getTotalCal()) \n\n")
                    }
                    print("kcal today: \(macrosAllocatedToday[Constants.CALORIES])")
                    print("protein today: \(macrosAllocatedToday[Constants.PROTEINS])")
                    print("carbohydrates today: \(macrosAllocatedToday[Constants.CARBOHYDRATES])")
                    print("fats today: \(macrosAllocatedToday[Constants.FATS])")
                    
                    let meal = Meal()
                    meal.name = String(mealIndex)
                    meal.foodItems.appendContentsOf(foodArray)
                    meal.date = NSCalendar.currentCalendar().dateByAddingUnit(.Day,value: Constants.DAYS_SINCE_START_OF_THIS_WEEK,toDate: Constants.START_OF_WEEK, options: [])!
                    dailyMealPlan.meals.append(meal)
                    
                }
            }
            //week.dailyMeals.append(dailyMealPlan)
            
        }
        
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
    func shouldAllowAdditionToMeal(dailymeal:DailyMealPlan, food:Food, week:Week) ->Bool{
        
        // delete this once the above is taken care of.
        if food.name.localizedCaseInsensitiveContainsString("lemon") || food.name.localizedCaseInsensitiveContainsString("lime"){
            return false
        }
        
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
    static func apportionFoodToGetGivenAmountOfMacro(foods:[Food], attribute:String, desiredQuantity:Double)->(foodItems:[FoodItem], isAddittionalFoodRequired:Bool)
    {
        var moreFoodsRequired = false
        var foodItems : [FoodItem] = []
        
        for food in foods {
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
            
            if (food.servingSize?.name != Constants.grams) && (food.servingSize?.name != Constants.ml) {
                fooditem.numberServing = ceil(desiredQuantity/foodAttributeAmount)
            }
            
            if Constants.isFat.evaluateWithObject(food){
                fooditem.numberServing = 0.1 //10g or 10ml of fat
                moreFoodsRequired = true
            }
            DataHandler.createFoodItem(fooditem)
            foodItems.append(fooditem)
            
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

