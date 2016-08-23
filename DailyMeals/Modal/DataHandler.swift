import UIKit
import RealmSwift

class DataHandler: NSObject {
    
    //MARK: Data Handler For Profile
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
    
    static func createUser(user:User){
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
    }
    static func updateUser(newData:User){
        let profile = getActiveUser()
        let realm = try! Realm()
        try! realm.write {
            
            profile.name                = newData.name
            profile.email               = newData.email
            profile.gender              = newData.gender
            profile.birthdate           = newData.birthdate
            
        }
    }
    static func updateStep1(bio:Biographical){
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
    
    static func updateProfileDiet(newData:String){
        let profile = getActiveBiographical()
        let realm = try! Realm()
        try! realm.write {
            profile.dietaryMethod = newData
            
        }
    }
    static func updateLikeFoods(newData:NSMutableArray){
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
    
    static func updateDisLikeFoods(newData:NSMutableArray){
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
    static func createMeal(meal:Meal){
        let realm = try! Realm()
        try! realm.write {
            realm.add(meal)
            //print("creating Meal \(meal.name )")
        }
    }
    
    static func addFoodItemToMeal(meal:Meal,foodItem:FoodItem){
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
    
    
    
    static func removeFoodItem(foodItem:FoodItem){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(foodItem)
        }
    }
    static func removeFoodItemFromMeal(meal:Meal,index:Int){
        let realm = try! Realm()
        try! realm.write {
            meal.foodItems.removeAtIndex(index)
        }
    }
    static func createFoodItem(foodItem:FoodItem){
        let realm = try! Realm()
        try! realm.write {
            realm.add(foodItem)
            //print("creating FoodItem \(foodItem.food!.name )")
        }
        
    }
    static func updateFoodItem(foodItem:FoodItem,numberServing:Double){
        let realm = try! Realm()
        try! realm.write {
            foodItem.numberServing = numberServing
           // print("updating FoodItem \(foodItem.food!.name )")
        }
        
    }
    //MARK: Data Handler For Profile
    static func getFood(pk:Int)->Food?{
        let realm = try! Realm()
        let object = realm.objects(Food).filter("pk = "+pk.description).first
        if((object) != nil){
            return object!
        }else{
            return  nil;
        }
    }
    static func getOrCreateFood(pk:Int)->Food{
        var food = getFood(pk);
        if(food == nil){
            food = Food();
            food!.pk = pk;
            createFood(food!);
        }
        return food!;
        
    }
    static func createFood(food:Food)->Food{
        
        let getfood = getFood(food.pk);
        if(getfood != nil){
            //Alredy exist
            return getfood!;
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(food)
           // print("creating Food \(food.name )")
        }
        return food
        
    }
    static func createDailyMeal(dailyMeal:DailyMealPlan){
        let realm = try! Realm()
        try! realm.write {
            realm.add(dailyMeal)
        }
    }
    static func createWeeklyMeal(week:Week){
        let realm = try! Realm()
        try! realm.write {
            realm.add(week)
        }
    }
    static func addMealToDailyMeal(dailyMeal:DailyMealPlan, meal:Meal){
        let realm = try! Realm()
        try! realm.write {
            dailyMeal.meals.append(meal);
        }
    }
    static func readfoodData(productId:Int,success:((sucess:Food)->Void)){
        dispatch_async(dispatch_queue_create("background", nil)) {
            let realm = try! Realm()
            let items = realm.objects(Food).filter("pk = " + productId.description).first
            if((items) != nil){
                success(sucess: items!);
            }
        }
    }
    static func readFoodsData(name:String)->[Food]{
        let realm = try! Realm()
        let items = realm.objects(Food).filter("name contains '" + name + "' and pk != 0")
        return Array(items)
    }
    
    static func getAllFoodsExceptLikedFoods(name:String)->[Food]{
        let realm = try! Realm()
        let foodsLiked = getLikeFoods().foods
        
        let namesOfFoodsLiked = NSMutableArray()
        for food in foodsLiked {
            
            namesOfFoodsLiked.addObject(food.name)
            print("added \(food.name)")
            
        }
        
        let items = realm.objects(Food).filter("name contains '" + name + "' and pk != 0").filter("NOT name IN %@", namesOfFoodsLiked)
        print("NEW items contain : %f", items.count)
        
        return Array(items)
    }
    
    static func readMealData()->[Meal]{
        
        let realm = try! Realm()
        let items = realm.objects(Meal)
        return Array(items)
    }
    
    
    static func readMealData(day:Int)->DailyMealPlan{
        let realm = try! Realm()
        let weekNumber = self.getWeek(NSDate())
        let items = realm.objects(Week).first
        return (items?.dailyMeals[weekNumber-1])!;
    }
    
    
    // get the current week, which is the week ordered by start_date and the last object.
    // get todays date and find out how many days have lapsed since the start_date, = x
    // if x == 2 then get the second dailymeal in this weeks list of daily meals
    // display that on screen.
    
    static func getThisWeek()->Week
    {
        
        
        let calender = NSCalendar.currentCalendar()
        let aWeekAgo = calender.dateByAddingUnit(.Day, value: -6, toDate: calender.startOfDayForDate(NSDate()), options: [.MatchFirst])
        
        let realm = try! Realm()
        let latestWeekPredicate = NSPredicate(format: "start_date > %@", aWeekAgo!)
        
        return realm.objects(Week).filter(latestWeekPredicate).sorted("start_date", ascending: true).first!
    }
    
    /**
     This function gets all future week objects or creates them along with their meal plan.
     
     - Return Results<Week>
     
     */
    static func getFutureWeeks()-> Results<Week>
    {
        let calender = NSCalendar.currentCalendar()
        let aWeekAgo = calender.dateByAddingUnit(.Day, value: -6, toDate: calender.startOfDayForDate(NSDate()), options: [.MatchFirst])
        
        let realm = try! Realm()
        let latestWeekPredicate = NSPredicate(format: "start_date > %@", aWeekAgo!)
        
        let weeks = realm.objects(Week).filter(latestWeekPredicate).sorted("start_date", ascending: true)
        
        if (weeks.count == 0)
        {
            let kcal = calculateCalorieAllowance()
            let newKcal = Double(kcal) * 0.8
            
            let newWeek = Week()
            
            newWeek.name = String("1")
            
            newWeek.start_date = NSDate()
            
            newWeek.macroAllocation.appendContentsOf(macroAllocation())
            
            newWeek.calorieAllowance = kcal
            
            newWeek.TDEE = Int(newKcal)
            
            newWeek.dailyMeals.appendContentsOf(DataStructure.createMeal())
            
            
            //Next week
            let nextWeek = Week()
            nextWeek.name = String("2")
            nextWeek.start_date = startOfNextWeek()
            nextWeek.macroAllocation.appendContentsOf(macroAllocation())
            nextWeek.calorieAllowance = kcal
            nextWeek.TDEE = Int(newKcal)
            nextWeek.dailyMeals.appendContentsOf(DataStructure.createMeal())

            
            try! realm.write {
                realm.add(newWeek)
                realm.add(nextWeek)
                
            }
            
            return realm.objects(Week).filter(latestWeekPredicate).sorted("start_date", ascending: true)
        }
        
        else
        {
            return weeks
        }
        
        
        
    }
    
    static func startOfNextWeek() -> NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let dateComponets = calendar.components([.Weekday, .Hour], fromDate: NSDate())
        dateComponets.setValue(9-dateComponets.weekday, forComponent: .Weekday)
        
        dateComponets.setValue(dateComponets.hour * -1 + 8, forComponent: .Hour)
        let dateCustom = calendar.dateByAddingComponents(dateComponets, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        
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
            carb.value = (Double(kcal)*0.4)/4 //grams
            
            protein.name = Constants.PROTEINS
            protein.value = (Double(kcal)*0.4)/4 //grams
            
            fats.name = Constants.FATS
            fats.value = (Double(kcal)*0.2)/9 //grams
            
        }
        else
        {
            // carbs:30, protein:45, fat:25
            carb.name = Constants.CARBOHYDRATES
            carb.value = (Double(kcal)*0.3)/4 //grams
            
            protein.name = Constants.PROTEINS
            protein.value = (Double(kcal)*0.45)/4 //grams
            
            fats.name = Constants.FATS
            fats.value = (Double(kcal)*0.25)/9 //grams
        }
        
        let list = List() as List<Macronutrient>
        list.append(carb)
        list.append(protein)
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
        else
        {
            heightInCm = bio.heightMeasurement * Constants.INCH_TO_CM_CONSTANT
        }
        
        if bio.weightUnit == "kg" {
            weightInKg = bio.weightMeasurement
        }
        else
        {
            weightInKg = bio.weightMeasurement * Constants.POUND_TO_KG_CONSTANT
        }
        
        print("kConstant:\(kConstant) \n heightInCm: \(heightInCm) \n heightCoefficient:\(heightCoefficient) weightInKg: \(weightInKg) \n weightCoeffecient: \(weightCoeffecient) \n Age: \(Double(getAge())) \n ageCoefficient: \(ageCoefficient)")

        let k = kConstant + (heightInCm * heightCoefficient) + (weightInKg * weightCoeffecient) + (Double(getAge()) * ageCoefficient)
        print ("Calories allowed is: \(k)")
        return Int(k)
    }
    
    
    static func setCaloriesAndMealsForThisWeek()
    {
        //1. Get the current week
        let thisWeek = DataHandler.getThisWeek()
        
        // 2. get todays date and find out how many days have lapsed since the start_date
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: thisWeek.start_date, toDate: NSDate(), options: [])
        let daysLapsed = components.day
        
        //3. get todays meals
        let todaysMeals = thisWeek.dailyMeals[daysLapsed]
        
        
        //4. Set the number of TDEE and new calorie allowance for this week
        let tdee = calculateCalorieAllowance()
        let calorieAllowance = Double(tdee) * 0.8
        thisWeek.calorieAllowance = Int(calorieAllowance)
        thisWeek.TDEE = tdee
        
        //thisWeek.name = ""
        //thisWeek.macroAllocation = nil
        
        
        //5. Run the meal plan algorithm and set the meal plan for the week
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
        
        let now = NSDate()
        let nowComponents =  NSCalendar.currentCalendar().componentsInTimeZone(NSTimeZone.localTimeZone(), fromDate: now)
        let currentYear = nowComponents.year
        
        let birthComponents = NSCalendar.currentCalendar().componentsInTimeZone(NSTimeZone.localTimeZone(), fromDate: user.birthdate)
        let birthYear = birthComponents.year
        
        return (currentYear - birthYear)
    }
    
    /*
     * 06/06/2016
     * function : Get current week integer from specified date
     * parmeters: Current date
     * return   : Week integer value
     */
    static func getWeek(today:NSDate)->Int {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    let myComponents = myCalendar.components(.Weekday, fromDate: today)
    let weekNumber = myComponents.weekday
    return weekNumber
    }
    
    static func createFoodItem(item:Food,numberServing:Double)->FoodItem{
        let foodItem = FoodItem()
        foodItem.food = createFood(item);
        foodItem.numberServing = numberServing;
        DataHandler.createFoodItem(foodItem);
        return foodItem;
    }
    
    
    
}
