import UIKit
import RealmSwift

class DataHandler: NSObject {
    
    //MARK: Data Handler For Profile
    
    static func userExists()->Bool?{
        let realm = try! Realm()
        let user = realm.objects(User)
        if(user.count == 0){
            return false
        }else{
            return true
        }
    }
    
    static func getActiveUser()->User{
        let realm = try! Realm()
        let profile = realm.objects(User).first
        if((profile) != nil){
            return profile!
        }else{
            let pr  = User()
            createUser(pr);
            return  pr;
        }
    }
    static func getActiveBiographical()->Biographical{
        let realm = try! Realm()
        let profile = realm.objects(Biographical).first
        if((profile) != nil){
            return profile!
        }else{
            let pr  = Biographical()
            try! realm.write {
                realm.add(pr)
            }
            return  pr;
        }
    }
    //MARK: Data Handler For Profile
    static func getLikeFoods()->FoodsLiked{
        let realm = try! Realm()
        let profile = realm.objects(FoodsLiked).first
        if((profile) != nil){
            return profile!
        }else{
            let pr  = FoodsLiked()
            try! realm.write {
                realm.add(pr)
            }
            return  pr;
        }
    }
    
    //MARK: Data Handler For Profile
    static func getDisLikedFoods()->FoodsDisliked{
        let realm = try! Realm()
        let profile = realm.objects(FoodsDisliked).first
        if((profile) != nil){
            return profile!
        }else{
            let pr  = FoodsDisliked()
            try! realm.write {
                realm.add(pr)
            }
            return  pr;
        }
    }
    
    static func getBreakfastOnlyFoods()->[Food]{
        let realm = try! Realm()
        let breakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.onlyBreakfastFoodType)
        let breakfastFoods = realm.objects(Food).filter(breakfastPredicate)
        var foods : [Food] = []
        for f in breakfastFoods{
            foods.append(f)
        }
        return foods
    }

    
    static func createUser(_ user:User){
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
    }
    static func updateUser(_ newData:User){
        let profile = getActiveUser()
        let realm = try! Realm()
        try! realm.write {
            
            profile.name = newData.name.trimmingCharacters(in: NSCharacterSet.whitespaces)
            profile.email               = newData.email.trimmingCharacters(in: NSCharacterSet.whitespaces)
            profile.gender              = newData.gender
            profile.birthdate           = newData.birthdate
            
        }
    }
    static func updateStep1(_ bio:Biographical){
        let profile = getActiveBiographical()
        let realm = try! Realm()
        try! realm.write {
            
            profile.activityLevelAtWork                = bio.activityLevelAtWork
            profile.numberOfCardioSessionsEachWeek     = bio.numberOfCardioSessionsEachWeek
            profile.numberOfResistanceSessionsEachWeek = bio.numberOfResistanceSessionsEachWeek
            
            profile.numberOfDailyMeals         = bio.numberOfDailyMeals
            profile.looseFat.value          = bio.looseFat.value
            profile.gainMuscle.value        = bio.gainMuscle.value
            profile.addMoreDefinition.value = bio.addMoreDefinition.value
            profile.howLong           = bio.howLong
            
            profile.heightMeasurement = bio.heightMeasurement;
            profile.weightMeasurement = bio.weightMeasurement;
            
            profile.weightUnit = bio.weightUnit;
            profile.heightUnit = bio.heightUnit;
            
        }
    }
    
    static func updateProfileDiet(_ newData:String){
        let profile = getActiveBiographical()
        let realm = try! Realm()
        try! realm.write {
            profile.dietaryRequirement = newData
            
        }
    }
    static func updateLikeFoods(_ newData:NSMutableArray){
        let profile = getLikeFoods()
        let realm = try! Realm()
        
        try! realm.write {
            profile.foods.removeAll()
            for data in newData {
                
                if let item = data as? Food {
                    profile.foods.append(item);                    
                }
            }
        }
    }
    
    static func updateDisLikeFoods(_ newData:NSMutableArray){
        let profile = getDisLikedFoods()
        let realm = try! Realm()
        try! realm.write {
            profile.foods.removeAll()
            for data in newData {
                if let item = data as? Food {
                    profile.foods.append(item);
                }
            }
        }
    }
    
    
    //MARK:
    
    //MARK: Data Handler For Food
    static func createMeal(_ meal:Meal){
        let realm = try! Realm()
        try! realm.write {
            realm.add(meal)
            //print("creating Meal \(meal.name )")
        }
    }
    
    static func addFoodItemToMeal(_ meal:Meal,foodItem:FoodItem){
        print("addFoodItemToMeal called")
        
        // Check if meal contains food from foodItem
        
        var foodItemToUpdate: FoodItem?
        for fItem in meal.foodItems
        {
            if fItem.food!.name == foodItem.food!.name
            {
                foodItemToUpdate = fItem
            }
        }
        
        if foodItemToUpdate != nil
        {
            print(" found the same item in this meal. Going to update instead to: \((foodItemToUpdate?.numberServing)! + foodItem.numberServing ))")
            updateFoodItem(foodItemToUpdate!,numberServing:((foodItemToUpdate?.numberServing)! + foodItem.numberServing ))
            return
        }
        
        
        let realm = try! Realm()
        try! realm.write {
            meal.foodItems.append(foodItem)
            //print("creating Meal \(foodItem.food?.name )")
        }
    }
    
    
    
    static func removeFoodItem(_ foodItem:FoodItem){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(foodItem)
        }
    }
    /*
    static func removeFoodItemFromMeal(_ meal:Meal,index:Int){
        let realm = try! Realm()
        try! realm.write {
            meal.foodItems.removeAtIndex(index)
        }
    }
 */
    static func createFoodItem(_ foodItem:FoodItem){
        let realm = try! Realm()
        try! realm.write {
            realm.add(foodItem)
            print("creating FoodItem \(foodItem.food!.name )")
        }
        
    }
    static func updateFoodItem(_ foodItem:FoodItem,numberServing:Double){
        let realm = try! Realm()
        try! realm.write {
            foodItem.numberServing = numberServing
           // print("updating FoodItem \(foodItem.food!.name )")
        }
        
    }
    
    static func updateFoodItem(_ foodItem:FoodItem,eaten:Bool){
        let realm = try! Realm()
        try! realm.write {
            foodItem.eaten = eaten
            // print("updating FoodItem \(foodItem.food!.name )")
        }
        
    }
    //MARK: Data Handler For Profile
    static func getFood(_ pk:Int)->Food?{
        let realm = try! Realm()
        let object = realm.objects(Food).filter("pk = "+pk.description).first
        if((object) != nil){
            return object!
        }else{
            return  nil;
        }
    }
    static func getOrCreateFood(_ pk:Int)->Food{
        var food = getFood(pk);
        if(food == nil){
            food = Food();
            food!.pk = pk;
            createFood(food!);
        }
        return food!;
        
    }
    static func createFood(_ food:Food)->Food{
        
        let getfood = getFood(food.pk);
        if(getfood != nil){
            //Alredy exist
            return getfood!;
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(food)
            print("creating Food \(food.name )")
        }
        return food
        
    }
    static func createDailyMeal(_ dailyMeal:DailyMealPlan){
        let realm = try! Realm()
        try! realm.write {
            realm.add(dailyMeal)
        }
    }
    static func createWeeklyMeal(_ week:Week){
        let realm = try! Realm()
        try! realm.write {
            realm.add(week)
        }
    }
    static func addMealToDailyMeal(_ dailyMeal:DailyMealPlan, meal:Meal){
        let realm = try! Realm()
        try! realm.write {
            dailyMeal.meals.append(meal);
        }
    }
    static func readfoodData(_ productId:Int,success:@escaping ((_ sucess:Food)->Void)){
        DispatchQueue(label: "background", attributes: []).async {
            let realm = try! Realm()
            let items = realm.objects(Food).filter("pk = " + productId.description).first
            if((items) != nil){
                success(items!);
            }
        }
    }
    static func readFoodsData(_ name:String)->[Food]{
        let realm = try! Realm()
        let items = realm.objects(Food).filter("name contains '" + name + "' and pk != 0")
        return Array(items)
    }
    
    static func getAllFoodsExceptLikedFoods(_ name:String)->[Food]{
        let realm = try! Realm()
        let foodsLiked = getLikeFoods().foods
        
        let namesOfFoodsLiked = NSMutableArray()
        for food in foodsLiked {
            
            namesOfFoodsLiked.add(food.name)
            print("added \(food.name)")
            
        }
        
        let items = realm.objects(Food).filter("name contains '" + name + "' and pk != 0").filter("NOT name IN %@", namesOfFoodsLiked)
        print("NEW items contain : \(items.count)")
        
        return Array(items)
    }
    
    static func readMealData()->[Meal]{
        
        let realm = try! Realm()
        let items = realm.objects(Meal)
        return Array(items)
    }
    
    
    static func readMealData(_ day:Int)->DailyMealPlan{
        let realm = try! Realm()
        let weekNumber = self.getWeek(Date())
        let items = realm.objects(Week).first
        return (items?.dailyMeals[weekNumber-1])!;
    }
    
    static func createWeeks(_ weeksInTheFutureToCreate:[Int]) {
        let kcal = calculateCalorieAllowance()
        let newKcal = Double(kcal) * 0.95
        
        let realm = try! Realm()
        let numWeeks = realm.objects(Week).count + 1
        let calender = Calendar.current
        
        
        for weekInTheFuture in weeksInTheFutureToCreate{
            let newWeek = Week()
            newWeek.name = String(numWeeks + weekInTheFuture)
            let futureWeekStartDate = (calender as NSCalendar).date(byAdding: .day, value: (weekInTheFuture*7), to: calender.startOfDay(for: Date()), options: [.matchFirst])
            if (futureWeekStartDate != nil){
                newWeek.start_date = futureWeekStartDate!
            }
            newWeek.macroAllocation.append(objectsIn: macroAllocation())
            newWeek.calorieAllowance = kcal
            newWeek.TDEE = Int(newKcal)
            //newWeek.dailyMeals.appendContentsOf(DataStructure.createMeal())
            newWeek.dailyMeals.append(objectsIn: DataStructure.createMealPlans(newWeek))
            
            try! realm.write {
                realm.add(newWeek)
            }
        }
    }
    
    
    
    
    static func createThisWeekAndNextWeek()
    {
        
        print("createThisWeekAndNextWeek CALLED.")
        let realm = try! Realm()
        let calender = Calendar.current
        let aWeekAgo = (calender as NSCalendar).date(byAdding: .day, value: -6, to: calender.startOfDay(for: Date()), options: [.matchFirst])
        let futureWeeksPredicate = NSPredicate(format: "start_date > %@", aWeekAgo! as CVarArg)
        let weeks = realm.objects(Week).filter(futureWeeksPredicate).sorted(byProperty: "start_date", ascending: true).count
        
        
        
        var bangOn = 0
        var variance = 0.0
        let foods = realm.objects(Food)
        for food in foods {
            let foodCalculation : Double = (food.carbohydrates * 4) + (food.fats * 4) + (food.proteins * 9)
            if foodCalculation == food.calories{
                bangOn = bangOn + 1
            }
            variance = variance + (foodCalculation - food.calories)
        }
        
        print("Bang on: \((bangOn/foods.count)*100)%")
        print("The average variance is : \(variance/Double(foods.count))")
        
        
        switch weeks {
        case 0:
            createWeeks([0, 1])
        case 1:
            createWeeks([1])
        default:
            print("No weeks need to be created")
            return
        }
    }
    
    
    // get the current week, which is the week ordered by start_date and the last object.
    // get todays date and find out how many days have lapsed since the start_date, = x
    // if x == 2 then get the second dailymeal in this weeks list of daily meals
    // display that on screen.
    
    
    /**
     This function gets all future week objects or creates them along with their meal plan.
     
     - Return Results<Week>
     
     */
    static func getFutureWeeks()-> Results<Week>
    {
        let calender = Calendar.current
        let aWeekAgo = (calender as NSCalendar).date(byAdding: .day, value: -6, to: calender.startOfDay(for: Date()), options: [.matchFirst])
        
        let realm = try! Realm()
        let futureWeeksPredicate = NSPredicate(format: "start_date > %@", aWeekAgo! as CVarArg)
        
        let weeks = realm.objects(Week).filter(futureWeeksPredicate).sorted(byProperty: "start_date", ascending: true).count
        
        if weeks < 2 {
            createThisWeekAndNextWeek()
        }
        
        return realm.objects(Week.self).filter(futureWeeksPredicate).sorted(byProperty: "start_date", ascending: true)  
    }

    
    static func startOfNextWeek() -> Date
    {
        let calendar = Calendar.current
        let dateComponets = (calendar as NSCalendar).components([.weekday, .hour], from: Date())
        (dateComponets as NSDateComponents).setValue(9-dateComponets.weekday!, forComponent: .weekday)
        
        (dateComponets as NSDateComponents).setValue(dateComponets.hour! * -1 + 8, forComponent: .hour)
        let dateCustom = (calendar as NSCalendar).date(byAdding: dateComponets, to: Date(), options: NSCalendar.Options(rawValue: 0))
        
        return dateCustom!
    }
    
    
    
    static func macroAllocation()-> List<Macronutrient>
    {
        let kcal = calculateCalorieAllowance()
        let carb = Macronutrient()
        let protein = Macronutrient()
        let fats = Macronutrient()
        
        let aim = getActiveBiographical()
        if aim.looseFat.value == true
        {
            // carbs:40, protein:40, fat:20
            carb.name = Constants.CARBOHYDRATES
            carb.value = ceil((Double(kcal)*0.4)/4) //grams
            
            protein.name = Constants.PROTEINS
            protein.value = ceil((Double(kcal)*0.4)/4) //grams
            
            fats.name = Constants.FATS
            fats.value = ceil((Double(kcal)*0.2)/9) //grams
            
        }
        else
        {
            // carbs:30, protein:45, fat:25
            carb.name = Constants.CARBOHYDRATES
            carb.value = ceil((Double(kcal)*0.3)/4) //grams
            
            protein.name = Constants.PROTEINS
            protein.value = ceil((Double(kcal)*0.45)/4) //grams
            
            fats.name = Constants.FATS
            fats.value = ceil((Double(kcal)*0.25)/9) //grams
        }
        
        let list = List() as List<Macronutrient>
        list.append(protein)
        list.append(carb)
        list.append(fats)
        
        return list
    }
    
    
    static func calculateCalorieAllowance() -> Int
    {
        //"=66.5+(5*height in cm)+(13.75*weight in kg)-6.78*age in years"
        let bio = DataHandler.getActiveBiographical()
        let user = DataHandler.getActiveUser()
        
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
            print("User name \(user.name)")
            print("User dob \(user.birthdate.age)")
            print("User gender \(user.gender)")
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
        
        print("kConstant:\(kConstant) \n heightInCm: \(heightInCm) \n heightCoefficient:\(heightCoefficient) weightInKg: \(weightInKg) \n weightCoeffecient: \(weightCoeffecient) \n Age: \(Double(getAge())) \n ageCoefficient: \(ageCoefficient)")

        let k = kConstant + (heightInCm * heightCoefficient) + (weightInKg * weightCoeffecient) + (Double(getAge()) * ageCoefficient)
        
        
        var sessionsCount = Double(bio.numberOfCardioSessionsEachWeek + bio.numberOfResistanceSessionsEachWeek)
        if sessionsCount > 7{
            sessionsCount = 7 //min 0, max 7
        }
        let jobIntensity = Double(Constants.activityLevelsAtWork.index(of: bio.activityLevelAtWork!)!) + 1.0 //min 1, max 4
        let workOutIntensity = 3.0 //Upper end of between 1 and 4
        let n = Int(ceil((sessionsCount * workOutIntensity) + (jobIntensity))) //min 1, max 22
        
        assert(n > 0 && n < 28, "Error in the \(#function) as number of ")
        
        
        let distribution = [0.000, 1.200, 1.217, 1.234, 1.251, 1.268, 1.285, 1.302, 1.319, 1.335, 1.352, 1.369, 1.386, 1.403, 1.420, 1.437, 1.454, 1.471, 1.488, 1.505, 1.522, 1.539, 1.556, 1.573, 1.590, 1.606, 1.623, 1.640, 1.657, 1.674, 1.691, 1.708, 1.725]
        
        let tdee = distribution[n] * k
        print ("REE: \(k) \n TDEE:\(tdee) \n -5%\(tdee*0.95)")
        //The number of workouts multiplied by 2.5, and then adds the index of job intensity plus one to get A(n)
        
        // If aim is to gain muscle then add 10% if loose weight then reduce to 5% below TDEE or 20% whichever is the lowest of the two and then 5% each week.
        
        let aim = getActiveBiographical()
        if aim.gainMuscle.value == true {
            return Int(tdee * 1.1)
        }
        if aim.looseFat.value == true {
            return Int(tdee * 0.95)
        }
        // If the user wants to loose fat and gain muscle then we treat this as looseFat.
        return Int(tdee)
    }
    
    

    
    static func updateServingSizes()
    {
        var order = Constants.SERVING_SIZE_ORDER
        let realm = try! Realm()
        let sizes = realm.objects(ServingSize)
        for serving in sizes{
            if !order.contains(serving.name){
                order.append(serving.name)
            }
        }
    }
    
    
    
    static func getAge() -> Int
    {
        let user = DataHandler.getActiveUser()
        
        let now = Date()
        let nowComponents =  Calendar.current.dateComponents(in: TimeZone.autoupdatingCurrent, from: now)
        let currentYear = nowComponents.year
        
        let birthComponents = Calendar.current.dateComponents(in: TimeZone.autoupdatingCurrent, from: user.birthdate as Date)
        let birthYear = birthComponents.year
        
        return (currentYear! - birthYear!)
    }
    
    /*
     * 06/06/2016
     * function : Get current week integer from specified date
     * parmeters: Current date
     * return   : Week integer value
     */
    static func getWeek(_ today:Date)->Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let myCalendar = Calendar(identifier: Calendar.Identifier.iso8601)
    let myComponents = (myCalendar as NSCalendar).components(.weekday, from: today)
    let weekNumber = myComponents.weekday
    return weekNumber!
    }
    
    static func createFoodItem(_ item:Food,numberServing:Double)->FoodItem{
        let foodItem = FoodItem()
        foodItem.food = createFood(item);
        foodItem.numberServing = numberServing;
        DataHandler.createFoodItem(foodItem);
        return foodItem;
    }
    
    static func getFoodType(_ ft:String)->FoodType{
        let realm = try! Realm()
        let x = realm.objects(FoodType)
        for each in x {
            if each.name == ft{
                return each
            }
        }
        print("RETURNING THE WRONG FOODTYPE !!")
        return x.first!
    }
    
    
    

    
    
    
    /** INTERNAL TESTING */
    
    static func macrosCorrect() {
        let weeks = getFutureWeeks()
        
        let errorMargin = Constants.maximumNumberOfGramsToIgnore
        
        print("Week count == \(weeks.count)")
        for week in weeks{
            var dailyProtein = 0.0
            var dailyCarbs = 0.0
            var dailyFats = 0.0
            
            print(" Week \(week.name)")
            for dailyMealPlan in week.dailyMeals{
                dailyProtein = dailyProtein + dailyMealPlan.totalProteins()
                dailyCarbs = dailyCarbs + dailyMealPlan.totalCarbohydrates()
                dailyFats = dailyFats + dailyMealPlan.totalFats()
                
                
                if (week.macroAllocation.first!.value < dailyProtein + errorMargin) && (week.macroAllocation.first!.value > dailyMealPlan.totalProteins() - errorMargin){
                    print("Protein 😇")
                } else {
                    print("Protein 😫")
                }
                
                if (week.macroAllocation[1].value < dailyCarbs + errorMargin) && (week.macroAllocation[1].value > dailyMealPlan.totalCarbohydrates() - errorMargin){
                    print("Carbs 😇")
                } else {
                    print("Carbs 😫")
                }
                
                if (week.macroAllocation[2].value < dailyFats + errorMargin) && (week.macroAllocation[1].value > dailyMealPlan.totalFats() - errorMargin){
                    print("Fats 😇")
                } else {
                    print("Fats 😫")
                }
 
            }
            //print("\(dailyProtein, dailyCarbs, dailyFats)")
            
            
        }
    }
    
}
