import Foundation
import RealmSwift

class DataHandler: NSObject {

    static func foodsThatRequireRating()-> [Food] {
        let predicate = NSPredicate(format: "SELF.name IN %@", Constants.foods_that_require_rating)
        let realm = try! Realm()
        let foods = realm.objects(Food.self).filter(predicate)
        return foods.map({$0})
    }
    
    static func userExists()->Bool?{
        let realm = try! Realm()
        let user = realm.objects(User.self)
        if(user.count == 0){
            return false
        }else{
            return true
        }
    }
    
    static func getActiveUser()->User{
        let realm = try! Realm()
        let profile = realm.objects(User.self).first
        if((profile) != nil){
            return profile!
        }else{
            let pr  = User()
            createUser(pr);
            return  pr;
        }
    }
    
    //MARK: Biographical
    static func getActiveBiographical()->Biographical{
        let realm = try! Realm()
        let profile = realm.objects(Biographical.self).sorted(byKeyPath: "date", ascending: true).last
        ///let profile = realm.objects(Biographical.self).first
        if((profile) != nil){
            return profile!
        }else{
            let pr  = Biographical()
            try! realm.write {
                realm.add(pr)
            }
            return  pr
        }
    }
    
    static func updateWeightForNewWeek(newWeight:Int, unit:String?){
        let realm = try! Realm()
        let profile = getActiveBiographical()
        let newProfile : Biographical = Biographical()
        
        newProfile.date = Calendar.current.startOfDay(for: Date())
        newProfile.numberOfDailyMeals = profile.numberOfDailyMeals
        newProfile.mealplanDuration = profile.mealplanDuration
        newProfile.activityLevelAtWork = profile.activityLevelAtWork
        
        newProfile.dietaryRequirement.append(objectsIn: profile.dietaryRequirement)
        newProfile.gainMuscle = profile.gainMuscle
        newProfile.loseFat = profile.loseFat
        
        newProfile.numberOfResistanceSessionsEachWeek = profile.numberOfResistanceSessionsEachWeek
        newProfile.numberOfCardioSessionsEachWeek = profile.numberOfCardioSessionsEachWeek
        newProfile.hoursOfActivity = profile.hoursOfActivity
        
        newProfile.weightMeasurement = Double(newWeight)
        newProfile.weightUnit = profile.weightUnit
        newProfile.heightMeasurement = profile.heightMeasurement
        newProfile.heightUnit = profile.heightUnit
        
        
        try! realm.write {
            realm.add(newProfile)
        }
    }
    
    static func updateHeightWeight(_ bio:Biographical){
        let profile = getActiveBiographical()
        let realm = try! Realm()
        try! realm.write {
            profile.heightMeasurement = bio.heightMeasurement
            profile.weightMeasurement = bio.weightMeasurement
            profile.weightUnit = bio.weightUnit
            profile.heightUnit = bio.heightUnit
            
        }
    }
    
    static func updateStep1(_ bio:Biographical){
        let profile = getActiveBiographical()
        let realm = try! Realm()
        try! realm.write {
            
            profile.activityLevelAtWork                = bio.activityLevelAtWork
            profile.numberOfCardioSessionsEachWeek     = bio.numberOfCardioSessionsEachWeek
            profile.numberOfResistanceSessionsEachWeek = bio.numberOfResistanceSessionsEachWeek
            profile.hoursOfActivity = Double(bio.numberOfCardioSessionsEachWeek + bio.numberOfResistanceSessionsEachWeek)
            
            profile.numberOfDailyMeals         = bio.numberOfDailyMeals
            profile.loseFat.value          = bio.loseFat.value
            profile.gainMuscle.value        = bio.gainMuscle.value
            profile.mealplanDuration           = bio.mealplanDuration
            
            profile.heightMeasurement = bio.heightMeasurement
            profile.weightMeasurement = bio.weightMeasurement
            
            profile.weightUnit = bio.weightUnit;
            profile.heightUnit = bio.heightUnit;
            
        }
    }
    
    static func addDietTypeFollowed(_ dietsSelected:[String]){
        let profile = getActiveBiographical()
        let realm = try! Realm()
        var dietsTypesUserSubscribesTo : [DietSuitability] = []
        dietsTypesUserSubscribesTo = dietsSelected.map({
            realm.objects(DietSuitability.self).filter("name = %@", $0).first!
        })
        
        
        try! realm.write {
            for each in dietsTypesUserSubscribesTo {
                profile.dietaryRequirement.append(each)
            }
            
        }
    }

    //MARK: Foods
    static func getLikeFoods()->FoodsLiked{
        let realm = try! Realm()
        let profile = realm.objects(FoodsLiked.self).first
        if((profile) != nil){
            return profile!
        }else{
            let pr  = FoodsLiked()
            try! realm.write {
                realm.add(pr)
            }
            return  pr
        }
    }
    
    static func getDisLikedFoods()->FoodsDisliked{
        let realm = try! Realm()
        let profile = realm.objects(FoodsDisliked.self).first
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
    
    static func getNamesOfDisLikedFoods()->[String]{
        let realm = try! Realm()
        let profile = realm.objects(FoodsDisliked.self).first
        let results : [String] = (profile?.foods.map {$0.name})!
        if((profile) != nil){
            return results
        }else{
            return  [""];
        }
    }
    
    static func getBreakfastOnlyFoods()->[String]{
        let realm = try! Realm()
        let breakfastPredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.onlyBreakfastFoodType)
        let breakfastFoods = realm.objects(Food.self).filter(breakfastPredicate)
        var foodNames : [String] = []
        for f in breakfastFoods{
            foodNames.append(f.name)
        }
        return foodNames
    }

    //MARK: User
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
            
            profile.first_name = newData.first_name.trimmingCharacters(in: NSCharacterSet.whitespaces)
            profile.email               = newData.email.trimmingCharacters(in: NSCharacterSet.whitespaces)
            profile.gender              = newData.gender
            profile.birthdate           = newData.birthdate
            
        }
    }
    
        static func updateLikeFoods(_ newData:[Food]){
        let profile = getLikeFoods()
        let realm = try! Realm()
        
        try! realm.write {
            profile.foods.removeAll()
            for data in newData {
                
                if let item = data as Food? {
                    profile.foods.append(item);                    
                }
            }
        }
    }
    
    static func updateDisLikeFoods(_ newData:[Food]){
        let profile = getDisLikedFoods()
        let realm = try! Realm()
        try! realm.write {
            profile.foods.removeAll()
            for data in newData {
                if let item = data as Food? {
                    profile.foods.append(item);
                }
            }
        }
    }
    
    
    
    //MARK: Mealplans
static func deleteFutureMealPlansWeeksAndFoodItems(){
        let realm = try! Realm()
        let fooditems = realm.objects(FoodItem.self)
        let plans = realm.objects(DailyMealPlan.self)
        let weeks = realm.objects(Week.self)
        try! realm.write {
            realm.delete(fooditems)
            realm.delete(plans)
            realm.delete(weeks)
        }
    }
    
    static func deleteFutureMealPlans(){
        let objectsToDelete = SetUpMealPlan.getThisWeekAndNext()
        let realm = try! Realm()
        try! realm.write {
            realm.delete(objectsToDelete)
        }
    }
    
    static func deleteThisWeeksMealPlan(){
        
        if let objectsToDelete = SetUpMealPlan.getThisWeekAndNext().first {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(objectsToDelete)
            }
        }
    }
    
    
    static func deleteEverything(){
        let realm = try! Realm()
        let foods = realm.objects(Food.self)
        let fooditems = realm.objects(FoodItem.self)
        let plans = realm.objects(DailyMealPlan.self)
        let weeks = realm.objects(Week.self)
        let user = DataHandler.getActiveUser()
        let bio = DataHandler.getActiveBiographical()
        
        try! realm.write {
            realm.delete(foods)
            realm.delete(fooditems)
            realm.delete(plans)
            realm.delete(weeks)
            realm.delete(user)
            realm.delete(bio)
        }
    }
    
    
    static func createMeal(_ meal:Meal){
        let realm = try! Realm()
        try! realm.write {
            realm.add(meal)
        }
    }
    
    static func addFoodItemToMeal(_ meal:Meal,foodItem:FoodItem){
        
        // Check if meal contains food from foodItem
        
        var foodItemToUpdate: FoodItem?
        for fItem in meal.foodItems{
            if fItem.food!.name == foodItem.food!.name{
                foodItemToUpdate = fItem
                break
            }
        }
        
        if foodItemToUpdate != nil{
            updateFoodItem(foodItemToUpdate!,numberServing:((foodItemToUpdate?.numberServing)! + foodItem.numberServing ))
            return
        }
        
        
        let realm = try! Realm()
        try! realm.write {
            meal.foodItems.append(foodItem)
        }
    }
    
    
    
    static func removeFoodItem(_ foodItem:FoodItem){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(foodItem)
        }
    }
    
    static func moveFood(meals:List<Meal>, from:IndexPath, to:IndexPath){
        let realm = try! Realm()
        try! realm.write {
            
            if from.section == to.section{
                meals[from.section].foodItems.move(from: from.row, to: to.row)
            } else {
                let objectMoving = meals[from.section].foodItems[from.row]
                meals[to.section].foodItems.insert(objectMoving, at: to.row) //destination
                meals[from.section].foodItems.remove(objectAtIndex: from.row)
            }
            
            
            
            //meals.move(from: from.row, to: to.row)
        }
    }
    
    static func updateCalorieConsumption(thisWeek:Week){
        let realm = try! Realm()
        try! realm.write {
            thisWeek.caloriesEaten = thisWeek.calculateCalorieConsumptionForMeal()
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
        }
        
    }
    static func updateFoodItem(_ foodItem:FoodItem,numberServing:Double){
        let realm = try! Realm()
        try! realm.write {
            foodItem.numberServing = numberServing
        }
    }
    
    static func updateFoodItem(_ foodItem:FoodItem,eaten:Bool){
        let realm = try! Realm()
        try! realm.write {
            foodItem.eaten = eaten
            // print("updating FoodItem \(foodItem.food!.name )")
        }
        
    }
    
    static func updateMealPlanFeedback(_ lastWeek:Week, feedback: FeedBack){
        let realm = try! Realm()
        try! realm.write {
            lastWeek.feedback = feedback
        }
    }
    
    static func updateMacrosAndCalories(_ theWeek:Week, calories:Int, macros:[Macronutrient]){
        let realm = try! Realm()
        try! realm.write {
            theWeek.calorieAllowance = calories
            theWeek.macroAllocation.removeAll()
            theWeek.macroAllocation.append(objectsIn: macros)
        }
    }
    
    

    static func getFood(_ pk:Int)->Food?{
        let realm = try! Realm()
        let object = realm.objects(Food.self).filter("pk = "+pk.description).first
        if((object) != nil){
            return object!
        }else{
            return  nil;
        }
    }
    static func getFoodRandam(_ pk:Int)->Food?{
        let realm = try! Realm()
        let object = realm.objects(Food.self);
           if (object.count > pk){
                return object[pk];
        }else{
            return  nil;
        }
    }
    static func getOrCreateFood(_ pk:Int)->Food{
        var food = getFood(pk);
        if(food == nil){
            food = Food();
            food!.pk = pk;
            _ = createFood(food!);
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
        }
        return food
        
    }
    
    static func getNewPKForFood() -> Int?{
        let realm = try! Realm()
        let count = realm.objects(Food.self).count
        return ((count + 1) * -1)
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
            let items = realm.objects(Food.self).filter("pk = " + productId.description).first
            if((items) != nil){
                success(items!);
            }
        }
    }
    static func readFoodsData(_ name:String)->[Food]{
        let realm = try! Realm()
        let items = realm.objects(Food.self).filter("name contains '" + name + "' and pk != 0").sorted(byProperty: "name", ascending: true)
        return Array(items)
    }
    
    static func getAllFoodsExceptLikedFoods(_ name:String)->[Food]{
        let realm = try! Realm()
        let foodsLiked = getLikeFoods().foods
        let foodsIEat = getFoodsForYourDiet().map({$0.name})
        
        let namesOfFoodsLiked = NSMutableArray()
        for food in foodsLiked {
            namesOfFoodsLiked.add(food.name)
        }
        let pred = NSPredicate(format:"NOT SELF.name IN %@ AND SELF.name IN %@", namesOfFoodsLiked, foodsIEat)
        
        let items = realm.objects(Food.self).filter("name contains '" + name + "' and pk != 0").filter(pred).sorted(byProperty: "name", ascending: true)
        return Array(items)
        //et dislikedFoodsPredicate = NSPredicate(format: "NOT SELF.name IN %@", dislikedFoods)
    }
    
    static func getFoodsForYourDiet() -> [Food]{
        let realm = try! Realm()
        let vegetarianPredicate = NSPredicate(format: "name = %@ OR name = %@", Constants.vegetarian, Constants.Vegan)
        let myDiets = realm.objects(DietSuitability.self).filter(vegetarianPredicate)
        if myDiets.count > 0{
            return Array(realm.objects(Food.self).filter("ANY SELF.dietSuitability IN %@", myDiets).sorted(byProperty: "name", ascending: true))
            
        }
        return Array(realm.objects(Food.self))
    }
    
    static func readMealData()->[Meal]{
        
        let realm = try! Realm()
        let items = realm.objects(Meal.self)
        return Array(items)
    }
    
    
    static func readMealData(_ day:Int)->DailyMealPlan{
        let realm = try! Realm()
        let weekNumber = self.getWeek(Date())
        let items = realm.objects(Week.self).first
        return (items?.dailyMeals[weekNumber-1])!;
    }
    
    
    static func updateServingSizes()
    {
        var order = Constants.SERVING_SIZE_ORDER
        let realm = try! Realm()
        let sizes = realm.objects(ServingSize.self)
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
        foodItem.food = item //createFood(item)
        foodItem.numberServing = numberServing
        DataHandler.createFoodItem(foodItem)
        return foodItem;
    }
    
    static func getFoodType(_ ft:String)->FoodType{
        let realm = try! Realm()
        let x = realm.objects(FoodType.self)
        for each in x {
            if each.name == ft{
                return each
            }
        }
        print("Error.")
        return x.first!
    }
    
    
    static func getCondimentFoodType()->FoodType{
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name = %@", Constants.condimentFoodType)
        let condiment = realm.objects(FoodType.self).filter(predicate)
        return condiment.first!
    }
    
    
    
    
    

    
    
    
    /** INTERNAL TESTING */
    
    static func macrosCorrect() {
        let weeks = SetUpMealPlan.getThisWeekAndNext()
        
        let errorMargin = Constants.maximumNumberOfGramsToIgnore
        
        print("Week count == \(weeks.count)")
        for week in weeks{
            var dailyProtein = 0.0
            var dailyCarbs = 0.0
            var dailyFats = 0.0
            
            print(" Week \(week.number)")
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
