
import Foundation
import RealmSwift

class FoodType: Object {
    
    dynamic var name = ""
    let foods = LinkingObjects(fromType: Food.self, property: "foodType")
    
    /*
    var foods: [Food] {
        // Realm doesn't persist this property because it only has a getter defined
        return LinkingObjects(fromType:Food, property: "foodType")
    }
 */
    
    static func addFoodTypes(){
        
        let eatenAtBreakfastFoodType = FoodType()
        eatenAtBreakfastFoodType.name = Constants.eatenAtBreakfastFoodType
        
        let onlyBreakfastFoodType = FoodType()
        onlyBreakfastFoodType.name = Constants.onlyBreakfastFoodType
        
        let fish = FoodType()
        fish.name = Constants.fish
        
        let vegetableFoodType = FoodType()
        vegetableFoodType.name = Constants.vegetableFoodType
        
        let fruitFoodType = FoodType()
        fruitFoodType.name = Constants.fruitFoodType
        
        let fizzy = FoodType()
        fizzy.name = Constants.fizzy
        
        let drinkFoodType = FoodType()
        drinkFoodType.name = Constants.drinkFoodType
        
        let condimentFoodType = FoodType()
        condimentFoodType.name = Constants.condimentFoodType
        
        let meatFoodType = FoodType()
        meatFoodType.name = Constants.meatFoodType
        
        
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(eatenAtBreakfastFoodType)
            realm.add(onlyBreakfastFoodType)
            realm.add(fish)
            realm.add(vegetableFoodType)
            realm.add(fruitFoodType)
            realm.add(fizzy)
            realm.add(drinkFoodType)
            realm.add(condimentFoodType)
            realm.add(meatFoodType)
            
        }
        
        
    }
}
