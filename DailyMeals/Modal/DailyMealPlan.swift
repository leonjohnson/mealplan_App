import Foundation
import RealmSwift

class DailyMealPlan: Object {
    
    dynamic var dayId = 0; //  Day of the week can vary from 1 to 7
    let meals = List<Meal>() // A list of meals to be eaten this day
}

