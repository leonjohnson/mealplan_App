import Foundation
import RealmSwift

class Week: Object {
    
    dynamic var name = "" // 1,2,3 etc but this may include strings at a later date
    dynamic var start_date = Calendar.current.startOfDay(for: Date())
    let dailyMeals = List<DailyMealPlan>()
    let macroAllocation = List<Macronutrient>()
    dynamic var feedback:FeedBack?
    dynamic var TDEE : Int = 0 // What I need
    dynamic var calorieAllowance:Int = 0 // Recommended for this stage in my journey
    dynamic var calorieConsumption:Int = 0 // what I ate this week. Lets assume that I ate everything in my meal plan for now.
    
    
    func calculateCalorieConsumptionForMeal()->Int{
        var totalCalories = 0
        for mealplan in dailyMeals{
            totalCalories = totalCalories + Int(mealplan.totalKcalOfEatenFoods())
        }
        print("calculateCalorieConsumptionForMeal: \(totalCalories)")
        return totalCalories/dailyMeals.count
    }
    
    func lastWeek()->Week?{
        let calendar = Constants.Calendar.usersCalendar
        let aWeekAgo = (calendar as NSCalendar).date(byAdding: .day, value: -14, to: calendar.startOfDay(for: self.start_date), options: [.matchFirst])
        let aWeekAgoPredicate = NSPredicate(format: "start_date > %@", aWeekAgo! as CVarArg)
        
        let realm = try! Realm()
        let lastWeek = realm.objects(Week.self).filter(aWeekAgoPredicate).sorted(byProperty: "start_date", ascending: true).first
        return lastWeek
    }
    
    func daysUntilWeekExpires()->Int{
        let calendar = Constants.Calendar.usersCalendar
        let endOfWeek = (calendar as NSCalendar).date(byAdding: .day, value: 7, to: self.start_date, options: [.matchFirst])
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: NSDate() as Date), to: endOfWeek!)
        return days.day!
    }
    
    
    func end_date()->Date{
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.day = 7
        components.hour = 12
        let endDate = calendar.date(byAdding: .day, value: 7, to: self.start_date)
        return endDate!
    }
    
    func currentWeek()->Week?{
        let calendar = Constants.Calendar.usersCalendar
        let aWeekAgo = (calendar as NSCalendar).date(byAdding: .day, value: -7, to: calendar.startOfDay(for: self.start_date), options: [.matchFirst])
        let aWeekAgoPredicate = NSPredicate(format: "start_date > %@", aWeekAgo! as CVarArg)
        let realm = try! Realm()
        let currentWeek = realm.objects(Week.self).filter(aWeekAgoPredicate).sorted(byProperty: "start_date", ascending: true).first
        return currentWeek
    }
    
    /*
    Decision: Keep calorieAllowance and TDEE to Week level
    The calorie allowance and TDEE could be put at a daily level as the user could theortecially change this
    mid-week. However, the only implication of this is that we cannot see a record of all changes.
    To increase this data storage six fold (by adding it to 7 days instead of 1 week), seems excessive for little gain.
    
    Decision: Store both TDEE and calorie allowance
    I may need to understand these numbers in seperation so they're being stored seperately.
    */
}
