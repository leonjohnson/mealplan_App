import Foundation
import RealmSwift

class DietSuitability: Object {
    dynamic var name = ""
    
     static func addRowData(){
        
        let dietSuitability1 = DietSuitability();
        dietSuitability1.name = "Gluten free"
        
        let dietSuitability2 = DietSuitability();
        dietSuitability2.name = "Vegan"
        
        let dietSuitability3 = DietSuitability();
        dietSuitability3.name = "Vegetarian"
        
        let dietSuitability4 = DietSuitability();
        dietSuitability4.name = "Lactose free"
        

        
        let realm = try! Realm()
        try! realm.write {
            realm.add(dietSuitability1);
            realm.add(dietSuitability2);
            realm.add(dietSuitability3);
            realm.add(dietSuitability4);
        }
        
        
    }
    
}
