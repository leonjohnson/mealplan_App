import Foundation
import RealmSwift

class Food: Object {

    dynamic  var pk             = 1;
    dynamic  var name           = "";
    dynamic  var producer       = ""
    dynamic  var calories       = 0.0
    dynamic  var fats           = 0.0
    var sat_fats = RealmOptional<Double>()
    dynamic  var carbohydrates   = 0.0
    var sugars = RealmOptional<Double>()
    var fibre = RealmOptional<Double>()
    dynamic  var proteins        = 0.0
    dynamic var salt : Double = 0.00
    
    
    dynamic  var image          = ""
    dynamic  var servingSize : ServingSize? = nil
    dynamic var authoredBy: User? //Should this be a string or a User object. Users will be just you and us?
    var dietSuitablity = List<DietSuitability>()
    var foodType = List<FoodType>()
    dynamic var spicy = false
    
    
    dynamic var vitaminB1: String? = nil
    dynamic var vitaminB2: String? = nil
    dynamic var vitaminB3: String? = nil
    dynamic var vitaminB6: String? = nil
    dynamic var calcium: String? = nil
    dynamic var vitaminC: String? = nil
    dynamic var vitaminD: String? = nil
    dynamic var deprecated = false
    dynamic var readyToEat = false
    
    var oftenEatenWith = List<Food>()
    var alwaysEatenWithOneOf = List<Food>()
    
    
    
    
    
    /*
    
    Food is an object of the item wich is awailable for a meal plan
    Considering the workout as a Food with product id = 0;
    
    */
    
}
