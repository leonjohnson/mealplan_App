import Foundation
import RealmSwift

class Meal: Object {
    
    dynamic var name = "" // 1,2,3, Working day breakfast, leg day dinner etc
    dynamic var date = NSDate()
    let foodItems = List<FoodItem>()
    // Each Meal contains a FoodItem list, each food item within the foods list contains its nutritional and characteristic information.
    
    
    // NB:  A meals plan is always a array of meals
}
