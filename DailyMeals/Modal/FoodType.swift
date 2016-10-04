
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
        foodType1.name = "Eaten At Breakfast"
        
        let foodType2 = FoodType();
        foodType2.name = "Breakfast only"
        
        let foodType3 = FoodType();
        foodType3.name = "White fish"
        
        let foodType4 = FoodType();
        foodType4.name = "Vegetable"
        
        let foodType5 = FoodType();
        foodType5.name = "Fruit"
        
        let foodType6 = FoodType();
        foodType6.name = "Fizzy"
        
        let foodType7 = FoodType();
        foodType7.name = "Drink"
        
        let foodType8 = FoodType();
        foodType8.name = "Condiment"
        
        
        
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
