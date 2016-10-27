
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
        
        let foodType1 = FoodType();
        foodType1.name = Constants.eatenAtBreakfastFoodType
        
        let foodType2 = FoodType();
        foodType2.name = Constants.onlyBreakfastFoodType
        
        let foodType3 = FoodType();
        foodType3.name = Constants.fish
        
        let foodType4 = FoodType();
        foodType4.name = Constants.vegetableFoodType
        
        let foodType5 = FoodType();
        foodType5.name = Constants.fruitFoodType
        
        let foodType6 = FoodType();
        foodType6.name = Constants.fizzy
        
        let foodType7 = FoodType();
        foodType7.name = Constants.drinkFoodType
        
        let foodType8 = FoodType();
        foodType8.name = Constants.condiment
        
        
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(foodType1);
            realm.add(foodType2);
            realm.add(foodType3);
            realm.add(foodType4);
            realm.add(foodType5);
            realm.add(foodType6);
            realm.add(foodType7);
            realm.add(foodType8);
        }
        
        
    }
}
