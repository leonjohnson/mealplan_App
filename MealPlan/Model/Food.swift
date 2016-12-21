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
    var dietSuitability = List<DietSuitability>()
    var foodType = List<FoodType>()
    dynamic var spicy = false
    dynamic var coreFood = false
    
    var vitaminB1 = RealmOptional<Double>()
    var vitaminB2 = RealmOptional<Double>()
    var vitaminB3 = RealmOptional<Double>()
    var vitaminB6 = RealmOptional<Double>()
    var vitaminB12 = RealmOptional<Double>()
    var calcium = RealmOptional<Double>()
    var vitaminC = RealmOptional<Double>()
    var vitaminD = RealmOptional<Double>()
    var sodium = RealmOptional<Double>()
    var iron = RealmOptional<Double>()
    var potassium = RealmOptional<Double>()
    
    var deprecated = false
    dynamic var readyToEat = false
    
    var oftenEatenWith = List<Food>()
    var alwaysEatenWithOneOf = List<Food>()
    var similarFoods = List<Food>()
    
    dynamic var external_note = ""
    
    var max_number_of_servings = RealmOptional<Double>()
    var min_number_of_servings = RealmOptional<Double>()
    
    dynamic var doNotReduceToZero : Bool = false
    
    override static func ignoredProperties() -> [String] {
        return ["doNotReduceToZero"]
    }
    
    //var fields : Array = Array(arrayLiteral: "name", "producer", "salt", "calories", "fats", "sat_fats", "carbohydrates", "sugars", "fibre", "proteins", "salt", "dietSuitability",  "vitaminB1", "vitaminB2", "vitaminB3", "vitaminB6", "calcium", "vitaminC", "vitaminD")


    /*
    
    Food is an object of the item wich is awailable for a meal plan
    Considering the workout as a Food with product id = 0;
     
    */
    
    func macro()->String? {
        
        if foodType.contains(DataHandler.getFoodType(Constants.vegetableFoodType)) {
            return Constants.vegetableFoodType
        }
        
        if proteins > fats && proteins > carbohydrates{
            return Constants.PROTEINS
        }
        if carbohydrates > fats && carbohydrates > proteins{
            return Constants.CARBOHYDRATES
        }
        if fats > carbohydrates && fats > proteins{
            return Constants.FATS
        }
        
        return nil
    }
    
    
}
