import Foundation
import RealmSwift

class Week: Object {
    
    dynamic var name = "" // 1,2,3 etc but this may include strings at a later date
    dynamic var start_date = Date()
    let dailyMeals = List<DailyMealPlan>()
    let macroAllocation = List<Macronutrient>()
    dynamic var feedback:FeedBack?
    dynamic var calorieAllowance : Int = 0
    dynamic var TDEE : Int = 0
    
    
    
    /*
    Decision: Keep calorieAllowance and TDEE to Week level
    The calorie allowance and TDEE could be put at a daily level as the user could theortecially change this
    mid-week. However, the only implication of this is that we cannot see a record of all changes.
    To increase this data storage six fold (by adding it to 7 days instead of 1 week), seems excessive for little gain.
    
    Decision: Store both TDEE and calorie allowance
    I may need to understand these numbers in seperation so they're being stored seperately.
    */
}
