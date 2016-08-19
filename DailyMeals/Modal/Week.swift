import Foundation
import RealmSwift

class Week: Object {
    
    dynamic var name = "" // 1,2,3 etc but this may include strings at a later date
    dynamic var start_date = NSDate()
    let dailyMeals = List<DailyMealPlan>()
    let macroAllocation = List<Macronutrient>()
    dynamic var feedback:FeedBack?
    dynamic var calorieAllowance : Int = 0
    dynamic var TDEE : Int = 0
    
    
}
