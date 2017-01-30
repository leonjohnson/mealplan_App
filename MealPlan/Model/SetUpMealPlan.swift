import Foundation
import RealmSwift

class SetUpMealPlan: NSObject {

    static func loadDatabaseWithData(){
        
        if (Config.getBoolValue("isCreated")){
            return
        }
        
        DietSuitability.addRowData();
        FoodType.addFoodTypes()
        loadDatInBackroundThread()
    }
    
    static func loadDatInBackroundThread(){
        DispatchQueue.global(qos: .background).async {
            Connect.fetchInitialFoods(nil) { (foods, json, status) -> Void in
                
                if(status == false){

                    // @todo show an alert that we need a alert here
                    return
                }

                //Load nutritional information for these foods.
                for  food in foods!{
                    _ = DataHandler.createFood(food);
                }

                //Add the food pairings
                addFoodPairingsToDatabase(foods!,json: json)

                //createMeal();
                Config.setBoolValue("isCreated", status: true);
                
            }

            DispatchQueue.main.async {
                print("back to main main queue after complete")
            }
        }
    }
    
    
    
    
    
    /**
     This function takes an array of foods and their attributes and inputs any foods labelled as 'oftenEatenWith'
     or 'alwaysEatenWithOneOf' into the database.
     
     
     - parameter foods: A List of Foods in the database that don't have 'oftenEatenWith' or 'alwaysEatenWithOneOf' yet.
     - parameter json: NSArray of foods and their attributes including.
     
     
     */
    static func addFoodPairingsToDatabase (_ foods:[Food], json:NSArray)
    {
        
        let realm = try! Realm()
        for (index, food) in foods.enumerated() {
            
            let foodInJsonArray : NSDictionary = (json.object(at: index) as? NSDictionary)!
            let oftenEatenWith : NSArray = foodInJsonArray.object(forKey: "oftenEatenWith") as! NSArray
            let alwaysEatenWithOneOf : NSArray = foodInJsonArray.object(forKey: "alwaysEatenWithOneOf") as! NSArray
            
            let foodToEdit = realm.objects(Food.self).filter("name == %@", food.name)
            
            let realm = try! Realm()
            try! realm.write {
                
                if oftenEatenWith.count > 0 {
                    //for each in
                    let foodPredicate = NSPredicate(format: "name IN %@", oftenEatenWith)
                    let oew = realm.objects(Food.self).filter(foodPredicate)
                    foodToEdit.first!.setValue(List(oew), forKey: "oftenEatenWith")
                }
                
                if alwaysEatenWithOneOf.count > 0 {
                    let foodPredicate2 = NSPredicate(format: "name IN %@", alwaysEatenWithOneOf)
                    let aew = realm.objects(Food.self).filter(foodPredicate2)
                    foodToEdit.first!.setValue(List(aew), forKey: "alwaysEatenWithOneOf")
                }
                
            }
        }
        
    }

    
    static func isLoosingWeight(thisWeek:Week)->Bool? {
        let thisWeeksWeight = thisWeek.feedback?.weightMeasurement
        guard (thisWeek.lastWeek() != nil) else {
            return nil
        }
        let lastWeeksWeight = thisWeek.lastWeek()?.feedback?.weightMeasurement
        return Int(thisWeeksWeight!) < Int(lastWeeksWeight!) ? true : false
    }
    
    
    static func cutCalories(fromWeek :Week, userfoundDiet: Constants.dietEase)->Int{
        #if DEBUG
        print("cutCalories: \(userfoundDiet.rawValue)")
        #endif
        switch userfoundDiet {
        case .easy:
            return Int(Double(fromWeek.caloriesEaten) * Constants.standard_calorie_reduction_for_weightloss)
        case .ok:
            return Int(Double(fromWeek.caloriesEaten) * Constants.standard_calorie_reduction_for_weightloss)
        case .hard:
            return Int(Double(fromWeek.caloriesEaten) * Constants.standard_calorie_reduction_for_weightloss)
        case .veryHard:
            return fromWeek.caloriesEaten
        case .unstated:
            return Int(Double(fromWeek.caloriesEaten) * Constants.small_calorie_reduction_for_weightloss)
            
        }
    }
    
    
    static func initialCalorieCut(firstWeek:Week)->Int{
        
        // 1. determine (TDEE + 25%) which is the upper cap
        let cap = Int(Double(firstWeek.TDEE) * 1.25)
        
         // 2. If you're eating significantly less than your TDEE then your starting point should (TDEE x a reasonable cut). We can't sanction silly values which can happen if we cut from a very low calorie Consumption level.
        if Double(firstWeek.caloriesEaten) < Double(firstWeek.TDEE) * 0.8{
            return Int(Double(firstWeek.TDEE) * 0.8)
        } else {
            // 3. if my calories consumption last week is above the cap, then start me off on the cap, otherwise start me off on last weeks kcals minus my first cut
            let lastWeeksCaloriesMinusACut = Int(Double(firstWeek.caloriesEaten) * Constants.standard_calorie_reduction_for_weightloss)
            return firstWeek.calorieAllowance > cap ? cap : lastWeeksCaloriesMinusACut
        }
    }

    
    
    
    static func calculateInitialCalorieAllowance()->Int{
        
        let bio = DataHandler.getActiveBiographical()
        let user = DataHandler.getActiveUser()
        let tdee = Double(calculateTDEE(bio: bio, user: user))
        
        let aim = DataHandler.getActiveBiographical()
        if aim.gainMuscle.value == true {
            return Int(tdee * Constants.standard_calorie_increase_for_muscle)
        }
        if aim.loseFat.value == true {
            return Int(tdee * Constants.standard_calorie_reduction_for_weightloss)
        }
        return Int(tdee * Constants.standard_calorie_reduction_for_weightloss)
    }
    
    
    
    static func doesMealPlanExistForThisWeek(withTodaysDate: Date = Date())->(yayNay:Bool,weeksAheadIncludingCurrent:[Week]) {
        let realm = try! Realm()
        let calender = Calendar.current
        let today = calender.startOfDay(for: withTodaysDate)
        
        
        let todayPredicate = NSPredicate(format: "start_date == %@", today as NSDate)
        let mealPlanStartingToday = realm.objects(Week.self).filter(todayPredicate).first
        
        if mealPlanStartingToday != nil {
            let futureWeeksPredicate = NSPredicate(format: "start_date >= %@", today as NSDate)
            let weeksAhead = realm.objects(Week.self).filter(futureWeeksPredicate).sorted(byProperty: "start_date", ascending: true)
            let weeksAheadArray : [Week] = weeksAhead.map {$0}
            return (true, weeksAheadArray)
        }
        let aWeekAgo = (calender as NSCalendar).date(byAdding: .day, value: -7, to: calender.startOfDay(for: today), options: [.matchFirst])!
        
        let futureWeeksPredicate = NSPredicate(format: "start_date > %@", aWeekAgo as NSDate)
        
        let weeksAhead = realm.objects(Week.self).filter(futureWeeksPredicate).sorted(byProperty: "start_date", ascending: true)
        let weeksAheadArray : [Week] = weeksAhead.map {$0}
        
        if weeksAheadArray.count == 0 {
            return (false, weeksAheadArray)
        }
        return (true, weeksAheadArray)
    }
    
    static func createWeek(daysUntilCommencement:Int, calorieAllowance:Int) {
        let realm = try! Realm()
        let numberOfWeeks = realm.objects(Week.self).count + 1 // be careful, what if the user stops and restarts
        let calender = Calendar.current
        let newWeek = Week()
        newWeek.name = String(numberOfWeeks)
        let futureWeekStartDate = (calender as NSCalendar).date(
            byAdding: .day,
            value: daysUntilCommencement,
            to: calender.startOfDay(for: calender.startOfDay(for: Date())),
            options: [.matchFirst])
        if (futureWeekStartDate != nil){
            newWeek.start_date = futureWeekStartDate!
        }
        let newMacros = macroAllocation(calorieAllowance: calorieAllowance, weeksOnProgram: numberOfWeeks)
        newWeek.macroAllocation.append(objectsIn: newMacros)
        newWeek.calorieAllowance = calorieAllowance
        let bio = DataHandler.getActiveBiographical()
        let user = DataHandler.getActiveUser()
        newWeek.TDEE = calculateTDEE(bio: bio, user: user)
        let meals = MealPlanAlgorithm.createMealPlans(newWeek, withFoodBasket:nil)
        newWeek.dailyMeals.append(objectsIn: meals)
        newWeek.caloriesEaten = newWeek.calculateCalorieConsumptionForMeal()
        try! realm.write {
            realm.add(newWeek)
        }
    }
    
    static func createNewDailyMeaPlanslFor(week: Week)->[DailyMealPlan]{
        let meals = MealPlanAlgorithm.createMealPlans(week, withFoodBasket:nil)
        return meals
    }
    
    
    static func updateFutureWeeksWithNewMealPlans(){
        // find all future weeks and reset their meal plan
        let realm = try! Realm()
        let response = SetUpMealPlan.doesMealPlanExistForThisWeek()
        if response.weeksAheadIncludingCurrent.count == 0{
            return
        }
        let weeks = response.weeksAheadIncludingCurrent
        
        for week in weeks {
            let meals = SetUpMealPlan.createNewDailyMeaPlanslFor(week: week)
            try! realm.write {
                week.dailyMeals.removeAll()
                week.dailyMeals.append(objectsIn:meals)
                week.caloriesEaten = week.calculateCalorieConsumptionForMeal()
            }
        }
    }
    

    
    static func getThisWeekAndNext()-> Results<Week>
    {
        let calender = Calendar.current
        let aWeekAgo = (calender as NSCalendar).date(byAdding: .day, value: -7, to: calender.startOfDay(for: Date()), options: [.matchFirst])
        let realm = try! Realm()
        let futureWeeksPredicate = NSPredicate(format: "start_date > %@", aWeekAgo! as CVarArg)
        let weeks = realm.objects(Week.self).filter(futureWeeksPredicate).sorted(byProperty: "start_date", ascending: true)
        return realm.objects(Week.self).filter(futureWeeksPredicate).sorted(byProperty: "start_date", ascending: true)
    }
    
    
    static func startOfNextWeek() -> Date{
        let calendar = Calendar.current
        let dateComponets = (calendar as NSCalendar).components([.weekday, .hour], from: Date())
        (dateComponets as NSDateComponents).setValue(9-dateComponets.weekday!, forComponent: .weekday)
        
        (dateComponets as NSDateComponents).setValue(dateComponets.hour! * -1 + 8, forComponent: .hour)
        let dateCustom = (calendar as NSCalendar).date(byAdding: dateComponets, to: Date(), options: NSCalendar.Options(rawValue: 0))
        
        return dateCustom!
    }
    
    
    
    static func macroAllocation(calorieAllowance:Int, weeksOnProgram:Int)-> List<Macronutrient>{
        let carb = Macronutrient()
        let protein = Macronutrient()
        let fats = Macronutrient()
        
        // inch, cm, kg, pd
        var heightInMetres = 0.0
        var weightInKG = 0.0
        let aim = DataHandler.getActiveBiographical()
        if aim.heightUnit == "inch"{
            heightInMetres = (aim.heightMeasurement * Constants.INCH_TO_CM_CONSTANT)/100
        }else {
            heightInMetres = aim.heightMeasurement/100
        }
        
        if aim.heightUnit == Constants.POUNDS {
            weightInKG = aim.weightMeasurement * Constants.POUND_TO_KG_CONSTANT
        }else {
            weightInKG = aim.weightMeasurement
        }
        
        
        
        //BMI
        let upperLimitBMI : Double = 23
        let proxyForFatFreeMassInkg = heightInMetres * heightInMetres * upperLimitBMI
        #if DEBUG
            print("proxy is: \(proxyForFatFreeMassInkg)")
        #endif
        
        
        var proteinRequirement : Double = 0.0
        if aim.loseFat.value == true{
            proteinRequirement = weeksOnProgram < 4 ? (1.9 * proxyForFatFreeMassInkg) : (1.9 * proxyForFatFreeMassInkg)
        } else {
            proteinRequirement = weeksOnProgram < 4 ? (2.3 * proxyForFatFreeMassInkg) : (2.3 * proxyForFatFreeMassInkg)
        }
        //Protein is based on predicated amount of lean mass. 1.9 seems sensible, not too high like a bodybuilder.
        
        protein.name = Constants.PROTEINS
        protein.value = ceil(proteinRequirement) //grams
        
        fats.name = Constants.FATS
        fats.value = ceil((Double(calorieAllowance)*0.28)/9) //grams
        
        carb.name = Constants.CARBOHYDRATES
        let caloriesFromFats = (fats.value * 9.0)
        let caloriesFromProteins = (protein.value * 4.0)
        carb.value = ceil((Double(calorieAllowance) - caloriesFromFats - caloriesFromProteins)/4.0) //grams
        let list = List() as List<Macronutrient>
        list.append(protein)
        list.append(carb)
        list.append(fats)
        return list
    }
    
    
     static func calculateTDEE(bio:Biographical, user:User) -> Int {
        //"=66.5+(5*height in cm)+(13.75*weight in kg)-6.78*age in years"
        
        let gender = user.gender
        var weightCoeffecient = 0.0
        var heightCoefficient = 0.0
        var ageCoefficient = 0.0
        
        var kConstant = 0.0
        
        
        var heightInCm = 0.0
        var weightInKg = 0.0
        
        switch gender {
        case Constants.male:
            weightCoeffecient = Constants.maleWeightCoefficient
            heightCoefficient = Constants.maleHeightCoefficient
            ageCoefficient = Constants.maleAgeCoefficient
            kConstant = Constants.maleConstant
        case Constants.female:
            weightCoeffecient = Constants.femaleWeightCoefficient
            heightCoefficient = Constants.femaaleHeightCoefficient
            ageCoefficient = Constants.femaleAgeCoefficient
            kConstant = Constants.femaleConstant
        default:
            print("ERROR: gender not known")
        }
        
        
        if bio.heightUnit == "cm" {
            heightInCm = bio.heightMeasurement
        }
        else {
            heightInCm = bio.heightMeasurement * Constants.INCH_TO_CM_CONSTANT
        }
        
        if bio.weightUnit == "kg" {
            weightInKg = bio.weightMeasurement
        }
        else {
            weightInKg = bio.weightMeasurement * Constants.POUND_TO_KG_CONSTANT
        }
        
        //BMI
        let heightInMetres = heightInCm/100
        let upperLimitBMI : Double = 23
        let proxyForFatFreeMassInkg = heightInMetres * heightInMetres * upperLimitBMI
        
        
        let k = kConstant + (heightInCm * heightCoefficient) + (proxyForFatFreeMassInkg * weightCoeffecient) + (Double(DataHandler.getAge()) * ageCoefficient)
        
        
        var sessionsCount = bio.hoursOfActivity
        if sessionsCount > 7{
            sessionsCount = 7 //min 0, max 7
        }
        let jobIntensity = Double(Constants.activityLevelsAtWork.index(of: bio.activityLevelAtWork!)!) + 1.0 //min 1, max 4
        let workOutIntensity = 2.0 //Upper end of between 1 and 4
        let n = Int(ceil((sessionsCount * workOutIntensity) + (jobIntensity))) //min 1, max 22
        
        assert(n > 0 && n < 28, "Error in the \(#function) as number of ")
        
        
        let distribution = [0.000, 1.200, 1.217, 1.234, 1.251, 1.268, 1.285, 1.302, 1.319, 1.335, 1.352, 1.369, 1.386, 1.403, 1.420, 1.437, 1.454, 1.471, 1.488, 1.505, 1.522, 1.539, 1.556, 1.573, 1.590, 1.606, 1.623, 1.640, 1.657, 1.674, 1.691, 1.708, 1.725]
        
        let tdee = distribution[n] * k
        //The number of workouts multiplied by 2.5, and then adds the index of job intensity plus one to get A(n)
        
        #if DEBUG
            print("proxy in TDEE is: \(proxyForFatFreeMassInkg) AND TDEE: \(Int(tdee))")
        #endif
        return Int(tdee)
    }
    
    //* Mark
 
    
 
    
}
