import Foundation
import RealmSwift

class DailyMealPlan: Object {
    
    dynamic var dayId = 0; //  Day of the week can vary from 1 to 7
    let meals = List<Meal>() // A list of meals to be eaten this day
    
    func totalCalories()->Double{
        var totalKcal = 0.0
        for meal in meals{
            totalKcal = meal.totalCalories() + totalKcal
        }
        return  totalKcal
    }
    
    func totalCarbohydrates()->Double{
        var totalCarbohydrate = 0.0
        for meal in meals{
            totalCarbohydrate = meal.totalCarbohydrates() + totalCarbohydrate
        }
        return totalCarbohydrate
    }
    
    func totalProteins()->Double{
        var totalProtein = 0.0
        for meal in meals{
            totalProtein = meal.totalProteins() + totalProtein
        }
        return totalProtein
    }
    
    func totalFats()->Double{
        var totalFat = 0.0
        for meal in meals{
            totalFat = meal.totalFats() + totalFat
        }
        return totalFat
    }
}
