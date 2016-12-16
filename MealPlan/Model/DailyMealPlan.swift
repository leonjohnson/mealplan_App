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
    
    func calculateMacroDiscrepancy(macros: List<Macronutrient>)->(yesOrNo:Bool,amount:[String:Double]){
        
        var overAcceptableLimitBy : [String: Double] = [String:Double]()
        var totalProteins = 0.00
        var totalCarbs = 0.00
        var totalFats = 0.00
        for meal in self.meals{
            totalProteins = totalProteins + meal.totalProteins()
            totalCarbs = totalCarbs + meal.totalCarbohydrates()
            totalFats = totalFats + meal.totalFats()
        }
        
        if abs((totalProteins) - (macros[0].value)) > 7.0{
            overAcceptableLimitBy[Constants.PROTEINS] = abs((totalProteins) - (macros[0].value)) - 7.0
        } else {
            overAcceptableLimitBy[Constants.PROTEINS] = 0
        }
        
        
        if abs((totalCarbs) - (macros[1].value)) > 7.0{
            overAcceptableLimitBy[Constants.CARBOHYDRATES] = abs((totalCarbs) - (macros[1].value)) - 7.0
        } else {
            overAcceptableLimitBy[Constants.CARBOHYDRATES] = 0
        }
        
        
        if abs((totalFats) - (macros[2].value)) > 6.0{
            overAcceptableLimitBy[Constants.FATS] = abs((totalFats) - (macros[2].value)) - 6.0
        } else {
            overAcceptableLimitBy[Constants.FATS] = 0
        }
        
        /*overAcceptableLimitBy = [Constants.PROTEINS: abs((totalProteins) - (macros[0].value)),
                         Constants.CARBOHYDRATES: abs((totalCarbs) - (macros[1].value)),
                         Constants.FATS: abs((totalFats) - (macros[2].value))]
 */
        print("over Acceptable Limit By: \(overAcceptableLimitBy)")
        
        let significantVariance = (overAcceptableLimitBy[Constants.CARBOHYDRATES]! > 0.0 || overAcceptableLimitBy[Constants.PROTEINS]! > 0.0 || overAcceptableLimitBy[Constants.FATS]! > 0.0) ? true : false
        
        print("returning with: \(significantVariance)")
        return (significantVariance, overAcceptableLimitBy)
    }
    
    func containsFood(_ food:Food)->Bool{
        for meal in meals{
            for fi in meal.foodItems{
                if fi.food == food{
                    return true
                }
            }
        }
        return false
    }
    
    func foodNames()->[String]{
        var foodsArray:[String] = []
        for meal in meals{
            for fi in meal.foodItems{
                foodsArray.append(fi.food!.name)
                }
        }
        return foodsArray
    }
    
    func foods()->[Food]{
        var foodsArray:[Food] = []
        for meal in meals{
            for fi in meal.foodItems{
                foodsArray.append(fi.food!)
            }
        }
        return foodsArray
    }
    
    
    
    
}

