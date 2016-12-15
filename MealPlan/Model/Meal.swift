import Foundation
import RealmSwift

class Meal: Object {
    
    
    dynamic var name = "" // 1,2,3, Working day breakfast, leg day dinner etc
    dynamic var date = Date()
    let foodItems = List<FoodItem>()
    // Each Meal contains a FoodItem list, each food item within the foods list contains its nutritional and characteristic information.
    // NB:  A meals plan is always a array of meals
    
    /*
    func appendOrCombine(fi:FoodItem)
    {
        var newList : [FoodItem] = []
        for foodi in foodItems{
            if foodi.food?.name == fi.food?.name{
                fi.numberServing = fi.numberServing + foodi.numberServing
                newList.append(fi)
                return
            } else {
                newList.append(fi)
            }
        }
        self.foodItems = List(newList)
    }
 
    
    
    
    func appendOrCombineFoodItems(foodItems:[FoodItem])
    {
        for fi in foodItems{
            self.appendOrCombine(fi)
        }
        return
    }
 */
    func containsFood(food:Food) -> Bool {
        for foo in foodItems{
            if food.name == foo.food?.name{
                return true
            }
        }
        return false
    }
    
    func getFoodItem(food: Food) -> FoodItem?{
        for foo in foodItems{
            if food.name == foo.food?.name{
                return foo
            }
        }
        return nil
    }
    
    func totalCalories()->Double{
        var totalKcal = 0.0
        for fi in foodItems{
            totalKcal = fi.getTotalCal() + totalKcal
        }
        return  totalKcal
    }
    
    func totalCarbohydrates()->Double{
        var totalCarbohydrate = 0.0
        for fi in foodItems{
            totalCarbohydrate = ((fi.food?.carbohydrates)! * fi.numberServing) + totalCarbohydrate
        }
        return totalCarbohydrate
    }
    
    func totalProteins()->Double{
        var totalProtein = 0.0
        for fi in foodItems{
            totalProtein = ((fi.food?.proteins)! * fi.numberServing) + totalProtein
        }
        return totalProtein
    }
    
    func totalFats()->Double{
        var totalFat = 0.0
        for fi in foodItems{
            totalFat = ((fi.food?.fats)! * fi.numberServing) + totalFat
        }
        return totalFat
    }
    
    
}
